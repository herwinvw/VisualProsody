package visualprosody;

import java.util.Arrays;

import visualprosody.GradientDescent.Function;

public class VisualProsodyLe
{
    private final GaussianMixtureModel2 gmmPitchVoiced;
    private final GaussianMixtureModel2 gmmYawVoiced;
    private final GaussianMixtureModel2 gmmRollVoiced;
    private final GaussianMixtureModel2 gmmVelocityVoiced;
    private final GaussianMixtureModel2 gmmAccelerationVoiced;

    private final GaussianMixtureModel2 gmmPitchUnvoiced;
    private final GaussianMixtureModel2 gmmYawUnvoiced;
    private final GaussianMixtureModel2 gmmRollUnvoiced;
    private final GaussianMixtureModel2 gmmVelocityUnvoiced;
    private final GaussianMixtureModel2 gmmAccelerationUnvoiced;

    public VisualProsodyLe(GaussianMixtureModel2 gmmRollVoiced, GaussianMixtureModel2 gmmPitchVoiced, GaussianMixtureModel2 gmmYawVoiced,
            GaussianMixtureModel2 gmmVelocityVoiced, GaussianMixtureModel2 gmmAccelerationVoiced, GaussianMixtureModel2 gmmRollUnvoiced,
            GaussianMixtureModel2 gmmPitchUnvoiced, GaussianMixtureModel2 gmmYawUnvoiced, GaussianMixtureModel2 gmmVelocityUnvoiced,
            GaussianMixtureModel2 gmmAccelerationUnvoiced)
    {
        this.gmmPitchVoiced = gmmPitchVoiced;
        this.gmmYawVoiced = gmmYawVoiced;
        this.gmmRollVoiced = gmmRollVoiced;
        this.gmmVelocityVoiced = gmmVelocityVoiced;
        this.gmmAccelerationVoiced = gmmAccelerationVoiced;

        this.gmmPitchUnvoiced = gmmPitchUnvoiced;
        this.gmmYawUnvoiced = gmmYawUnvoiced;
        this.gmmRollUnvoiced = gmmRollUnvoiced;
        this.gmmVelocityUnvoiced = gmmVelocityUnvoiced;
        this.gmmAccelerationUnvoiced = gmmAccelerationUnvoiced;
    }

    private double getAcceleration(double[] rpy, double[] rpyPrev, double[] rpyPrevPrev)
    {
        double acceleration = 0;
        for (int i = 0; i < 3; i++)
        {
            acceleration += (rpy[i] - 2 * rpyPrev[i] + rpyPrevPrev[i])*(rpy[i] - 2 * rpyPrev[i] + rpyPrevPrev[i]);
        }
        return Math.sqrt(acceleration);
    }

    private double[] getAccelerationDiff(double[] rpy, double[] rpyPrev, double[] rpyPrevPrev)
    {
        double accelerationDiff = 0;
        for (int i = 0; i < 3; i++)
        {
            accelerationDiff += rpy[i] - 2 * rpyPrev[i] + rpyPrevPrev[i];
        }
        if (accelerationDiff < Double.MIN_NORMAL) return new double[] { 0, 0, 0 };
        accelerationDiff = Math.pow(accelerationDiff, -0.5d);
        double aDiff[] = new double[3];
        for (int i = 0; i < 3; i++)
        {
            aDiff[i] = accelerationDiff * (rpy[i] - 2 * rpyPrev[i] + rpyPrevPrev[i]);
        }
        return aDiff;
    }

    private double getVelocity(double[] rpy, double[] rpyPrev)
    {
        double velocity = 0;
        for (int i = 0; i < 3; i++)
        {
            velocity += (rpy[i] - rpyPrev[i]) * (rpy[i] - rpyPrev[i]);
        }
        return Math.sqrt(velocity);
    }

    private double[] getVelocityDiff(double[] rpy, double[] rpyPrev)
    {
        double velocityDiff = 0;
        for (int i = 0; i < 3; i++)
        {
            velocityDiff += (rpy[i] - rpyPrev[i]) * (rpy[i] - rpyPrev[i]);
        }
        if (velocityDiff < Double.MIN_NORMAL) return new double[] { 0, 0, 0 };
        velocityDiff = Math.pow(velocityDiff, -0.5d);
        double vDiff[] = new double[3];
        for (int i = 0; i < 3; i++)
        {
            vDiff[i] = velocityDiff * (rpy[i] - rpyPrev[i]);
        }
        return vDiff;
    }

    public double[] pDiff(double[] rpy, double[] rpyPrev, double[] rpyPrevPrev, double pitch, double rmsLoudness)
    {
        double vDiff[] = getVelocityDiff(rpy, rpyPrev);
        double aDiff[] = getAccelerationDiff(rpy, rpyPrev, rpyPrevPrev);
        double v = getVelocity(rpy, rpyPrev);
        double a = getAcceleration(rpy, rpyPrev, rpyPrevPrev);
        double vMinLogPDiff1;
        double aMinLogPDiff1;
        double[] pDiff = new double[3];
        if (pitch > 0)
        {
            pDiff[0] = gmmRollVoiced.logPDiff1(new double[] { rpy[0], pitch, rmsLoudness });
            pDiff[1] = gmmPitchVoiced.logPDiff1(new double[] { rpy[1], pitch, rmsLoudness });
            pDiff[2] = gmmYawVoiced.logPDiff1(new double[] { rpy[2], pitch, rmsLoudness });
            vMinLogPDiff1 = gmmVelocityVoiced.logPDiff1(new double[] { v, pitch, rmsLoudness });
            aMinLogPDiff1 = gmmAccelerationVoiced.logPDiff1(new double[] { a, pitch, rmsLoudness });
        }
        else
        {
            pDiff[0] = gmmRollUnvoiced.logPDiff1(new double[] { rpy[0], rmsLoudness });
            pDiff[1] = gmmPitchUnvoiced.logPDiff1(new double[] { rpy[1], rmsLoudness });
            pDiff[2] = gmmYawUnvoiced.logPDiff1(new double[] { rpy[2], rmsLoudness });
            vMinLogPDiff1 = gmmVelocityUnvoiced.logPDiff1(new double[] { v, rmsLoudness });
            aMinLogPDiff1 = gmmAccelerationUnvoiced.logPDiff1(new double[] { a, rmsLoudness });
        }
        for (int i = 0; i < 3; i++)
        {
            pDiff[i] += vMinLogPDiff1 * vDiff[i] + aMinLogPDiff1 * aDiff[i];
        }
//        System.out.println("v: "+v);
//        System.out.println("a: "+a);
//        System.out.println("vMinLogPDiff1: "+vMinLogPDiff1);
//        System.out.println("aMinLogPDiff1: "+aMinLogPDiff1);
//        
//        System.out.println("vDiff: "+Arrays.toString(vDiff));
//        System.out.println("aDiff: "+Arrays.toString(aDiff));
//        System.out.println("pDiff: "+Arrays.toString(pDiff));
        if(Double.isNaN(pDiff[0]))throw new RuntimeException("NaN");
        
        //find the maximum instead of the minimum
        for(int i=0;i<3;i++)
        {
            pDiff[i]=-pDiff[i];
        }
        
        return pDiff;        
    }

    public double[] generateHeadPose(final double rpyStartSearch[], final double rpyPrev[], final double rpyPrevPrev[], final double pitch, final double rmsLoudness)
    {
        Function f = new Function()
        {
            @Override
            public double[] evaluateDiff(double[] rpy)
            {
                /* numerical diff
                double delta = 0.001d;
                double p = p(rpy, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double proll = p(new double[] { rpy[0] + delta, rpy[1], rpy[2] }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double ppitch = p(new double[] { rpy[0], rpy[1] + delta, rpy[2] }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double pyaw = p(new double[] { rpy[0], rpy[1], rpy[2] + delta }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                System.out.println("Diff: "
                        + Arrays.toString(new double[] { (proll - p) / delta, (ppitch - p) / delta, (pyaw - p) / delta }));
                System.out.println("P: " + p);
                return new double[] { (proll - p) / delta, (ppitch - p) / delta, (pyaw - p) / delta };
                */
                
                return pDiff(rpy, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
            }
        };
        return GradientDescent.optimize(f, rpyStartSearch, 0.2d, 0.02d, 100);
    }
}
