package visualprosody;

import java.util.Arrays;

import visualprosody.GradientDescent.Function;
import weka.core.ConjugateGradientOptimization;
import weka.core.Optimization;
import edu.stanford.nlp.optimization.CGMinimizer;
import edu.stanford.nlp.optimization.DiffFunction;

public class VisualProsodyLeNumericalDiff
{
    private final GaussianMixtureModel gmmPitchVoiced;
    private final GaussianMixtureModel gmmYawVoiced;
    private final GaussianMixtureModel gmmRollVoiced;
    private final GaussianMixtureModel gmmVelocityVoiced;
    private final GaussianMixtureModel gmmAccelerationVoiced;

    private final GaussianMixtureModel gmmPitchUnvoiced;
    private final GaussianMixtureModel gmmYawUnvoiced;
    private final GaussianMixtureModel gmmRollUnvoiced;
    private final GaussianMixtureModel gmmVelocityUnvoiced;
    private final GaussianMixtureModel gmmAccelerationUnvoiced;

    private final double VELOCITY_SCALE = 1d / 8d;
    private final double ACCELERATION_SCALE = 1d / 16d;
    private double positionWeight = 1;
    private double velocityWeight = 1;
    private double accelerationWeight = 1;

    public VisualProsodyLeNumericalDiff(GaussianMixtureModel gmmRollVoiced, GaussianMixtureModel gmmPitchVoiced,
            GaussianMixtureModel gmmYawVoiced, GaussianMixtureModel gmmVelocityVoiced, GaussianMixtureModel gmmAccelerationVoiced,
            GaussianMixtureModel gmmRollUnvoiced, GaussianMixtureModel gmmPitchUnvoiced, GaussianMixtureModel gmmYawUnvoiced,
            GaussianMixtureModel gmmVelocityUnvoiced, GaussianMixtureModel gmmAccelerationUnvoiced)
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

    public void setVelocityWeight(double w)
    {
        this.velocityWeight = w;
    }

    public void setPositionWeight(double w)
    {
        this.positionWeight = w;
    }

    public void setAccelerationWeight(double w)
    {
        this.accelerationWeight = w;
    }

    public double minplogVelocityAndAcceleration(double[] rpy, double[] rpyPrev, double[] rpyPrevPrev, double pitch, double rmsLoudness)
    {
        double velocity = 0;
        for (int i = 0; i < 3; i++)
        {
            velocity += (rpy[i] - rpyPrev[i]) * (rpy[i] - rpyPrev[i]);
        }
        velocity = Math.sqrt(velocity);

        double acceleration = 0;
        for (int i = 0; i < 3; i++)
        {
            acceleration += (rpy[i] - 2 * rpyPrev[i] + rpyPrevPrev[i]) * (rpy[i] - 2 * rpyPrev[i] + rpyPrevPrev[i]);
        }
        acceleration = Math.sqrt(acceleration);

        if (pitch > 0)
        {
            return -Math.log(gmmVelocityVoiced.density(new double[] { velocity, pitch, rmsLoudness })) * VELOCITY_SCALE
                    - Math.log(gmmAccelerationVoiced.density(new double[] { acceleration, pitch, rmsLoudness })) * ACCELERATION_SCALE;
        }
        else
        {
            return 0;
        }
    }

    public double minplog(double[] rpy, double[] rpyPrev, double[] rpyPrevPrev, double pitch, double rmsLoudness)
    {
        double velocity = 0;
        for (int i = 0; i < 3; i++)
        {
            velocity += (rpy[i] - rpyPrev[i]) * (rpy[i] - rpyPrev[i]);
        }
        velocity = Math.sqrt(velocity);

        double acceleration = 0;
        for (int i = 0; i < 3; i++)
        {
            acceleration += (rpy[i] - 2 * rpyPrev[i] + rpyPrevPrev[i]) * (rpy[i] - 2 * rpyPrev[i] + rpyPrevPrev[i]);
        }
        acceleration = Math.sqrt(acceleration);

        if (pitch > 0)
        {
            return - positionWeight*Math.log(gmmRollVoiced.density(new double[] { rpy[0], pitch, rmsLoudness }))
                    - positionWeight*Math.log(gmmPitchVoiced.density(new double[] { rpy[1], pitch, rmsLoudness }))
                    - positionWeight*Math.log(gmmYawVoiced.density(new double[] { rpy[2], pitch, rmsLoudness }))
                    - Math.log(gmmVelocityVoiced.density(new double[] { velocity, pitch, rmsLoudness })) * VELOCITY_SCALE * velocityWeight
                    - Math.log(gmmAccelerationVoiced.density(new double[] { acceleration, pitch, rmsLoudness })) * ACCELERATION_SCALE
                    * accelerationWeight;
        }
        else
        {
            return 0;
            /*
             * return -Math.log(gmmRollUnvoiced.density(new double[] { rpy[0], rmsLoudness }))
             * - Math.log(gmmPitchUnvoiced.density(new double[] { rpy[1], rmsLoudness }))
             * - Math.log(gmmYawUnvoiced.density(new double[] { rpy[2], rmsLoudness }))
             * - Math.log(gmmVelocityUnvoiced.density(new double[] { velocity, rmsLoudness }));
             * - Math.log(gmmAccelerationUnvoiced.density(new double[] { acceleration, rmsLoudness }));
             */
        }
    }

    public double minp(double[] rpy, double[] rpyPrev, double[] rpyPrevPrev, double pitch, double rmsLoudness)
    {
        double velocity = 0;
        for (int i = 0; i < 3; i++)
        {
            velocity += (rpy[i] - rpyPrev[i]) * (rpy[i] - rpyPrev[i]);
        }
        velocity = Math.sqrt(velocity);

        double acceleration = 0;
        for (int i = 0; i < 3; i++)
        {
            acceleration += (rpy[i] - 2 * rpyPrev[i] + rpyPrevPrev[i]) * (rpy[i] - 2 * rpyPrev[i] + rpyPrevPrev[i]);
        }
        acceleration = Math.sqrt(acceleration);

        if (pitch > 0)
        {
            return -gmmRollVoiced.density(new double[] { rpy[0], pitch, rmsLoudness })
                    * gmmPitchVoiced.density(new double[] { rpy[1], pitch, rmsLoudness })
                    * gmmYawVoiced.density(new double[] { rpy[2], pitch, rmsLoudness })
                    * gmmVelocityVoiced.density(new double[] { velocity, pitch, rmsLoudness })
                    * gmmAccelerationVoiced.density(new double[] { acceleration, pitch, rmsLoudness });
        }
        else
        {
            return -gmmRollUnvoiced.density(new double[] { rpy[0], rmsLoudness })
                    * gmmPitchUnvoiced.density(new double[] { rpy[1], rmsLoudness })
                    * gmmYawUnvoiced.density(new double[] { rpy[2], rmsLoudness })
                    * gmmVelocityUnvoiced.density(new double[] { velocity, rmsLoudness })
                    * gmmAccelerationUnvoiced.density(new double[] { acceleration, rmsLoudness });
        }
    }

    public double[] generateHeadPoseDelta(final double rpyPrev[], final double rpyPrevPrev[], final double pitch, final double rmsLoudness)
    {
        Function f = new Function()
        {
            @Override
            public double[] evaluateDiff(double[] rpy)
            {
                double delta = 0.001d;
                double p = minplogVelocityAndAcceleration(rpy, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double proll = minplogVelocityAndAcceleration(new double[] { rpy[0] + delta, rpy[1], rpy[2] }, rpyPrev, rpyPrevPrev, pitch,
                        rmsLoudness);
                double ppitch = minplogVelocityAndAcceleration(new double[] { rpy[0], rpy[1] + delta, rpy[2] }, rpyPrev, rpyPrevPrev,
                        pitch, rmsLoudness);
                double pyaw = minplogVelocityAndAcceleration(new double[] { rpy[0], rpy[1], rpy[2] + delta }, rpyPrev, rpyPrevPrev, pitch,
                        rmsLoudness);
                return new double[] { (proll - p) / delta, (ppitch - p) / delta, (pyaw - p) / delta };
            }
        };
        double[] rpyVelAcc = GradientDescent.optimize(f, rpyPrev, 0.02d, 0.002d, 100);
        double rpy[] = new double[3];
        rpy[0] = rpyPrev[0] + (rpyVelAcc[0] - rpyPrev[0]) * gmmRollVoiced.density(new double[] { rpyVelAcc[0], pitch, rmsLoudness }) * 200;
        rpy[1] = rpyPrev[1] + (rpyVelAcc[1] - rpyPrev[1]) * gmmPitchVoiced.density(new double[] { rpyVelAcc[1], pitch, rmsLoudness }) * 200;
        rpy[2] = rpyPrev[2] + (rpyVelAcc[2] - rpyPrev[2]) * gmmYawVoiced.density(new double[] { rpyVelAcc[2], pitch, rmsLoudness }) * 200;
        return rpy;
    }

    public double[] generateHeadPoseWEKA(final double rpyPrev[], final double rpyPrevPrev[], final double pitch, final double rmsLoudness)
    {

        // DiffFunction f = new DiffFunction()
        // {
        //
        // @Override
        // public int domainDimension()
        // {
        // return 3;
        // }
        //
        // @Override
        // public double valueAt(double[] rpy)
        // {
        // return minplog(rpy, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
        // }
        //
        // @Override
        // public double[] derivativeAt(double[] rpy)
        // {
        // double delta = 0.001d;
        // double p = minplog(rpy, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
        // double proll = minplog(new double[] { rpy[0] + delta, rpy[1], rpy[2] }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
        // double ppitch = minplog(new double[] { rpy[0], rpy[1] + delta, rpy[2] }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
        // double pyaw = minplog(new double[] { rpy[0], rpy[1], rpy[2] + delta }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
        // return new double[] { (proll - p) / delta, (ppitch - p) / delta, (pyaw - p) / delta };
        // }
        // };
        // class MyOpt extends ConjugateGradientOptimization
        class MyOpt extends Optimization
        {
            // Provide the objective function
            protected double objectiveFunction(double[] rpy)
            {
                return minplog(rpy, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
            }

            // Provide the first derivatives
            protected double[] evaluateGradient(double[] rpy)
            {
                double delta = 0.001d;
                double p = minplog(rpy, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double proll = minplog(new double[] { rpy[0] + delta, rpy[1], rpy[2] }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double ppitch = minplog(new double[] { rpy[0], rpy[1] + delta, rpy[2] }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double pyaw = minplog(new double[] { rpy[0], rpy[1], rpy[2] + delta }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                return new double[] { (proll - p) / delta, (ppitch - p) / delta, (pyaw - p) / delta };
            }

            @Override
            public String getRevision()
            {
                return "";
            }
        }
        MyOpt opt = new MyOpt();
        double[][] constraints = new double[][] { { -90, -90, -90 }, { 90, 90, 90 } };
        // double[][] constraints = new double[][] { { Double.NaN, Double.NaN, Double.NaN }, { Double.NaN, Double.NaN, Double.NaN} };
        try
        {
            return opt.findArgmin(rpyPrev, constraints);
        }
        catch (Exception e)
        {
            throw new RuntimeException(e);
        }
    }

    public double[] generateHeadPoseStanfordNLP(final double rpyPrev[], final double rpyPrevPrev[], final double pitch,
            final double rmsLoudness)
    {
        DiffFunction f = new DiffFunction()
        {

            @Override
            public int domainDimension()
            {
                return 3;
            }

            @Override
            public double valueAt(double[] rpy)
            {
                return minplog(rpy, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
            }

            @Override
            public double[] derivativeAt(double[] rpy)
            {
                double delta = 0.001d;
                double p = minplog(rpy, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double proll = minplog(new double[] { rpy[0] + delta, rpy[1], rpy[2] }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double ppitch = minplog(new double[] { rpy[0], rpy[1] + delta, rpy[2] }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double pyaw = minplog(new double[] { rpy[0], rpy[1], rpy[2] + delta }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                return new double[] { (proll - p) / delta, (ppitch - p) / delta, (pyaw - p) / delta };
            }
        };

        /*
         * QNMinimizer qn = new QNMinimizer(15, true);
         * qn.shutUp();
         * return qn.minimize(f,0.001d,rpyPrev,10000);
         */
        CGMinimizer cn = new CGMinimizer(true);
        return cn.minimize(f, 0.0000001, rpyPrev);
    }

    public double[] generateHeadPose(final double rpyPrev[], final double rpyPrevPrev[], final double pitch, final double rmsLoudness)
    {
        Function f = new Function()
        {
            @Override
            public double[] evaluateDiff(double[] rpy)
            {
                double delta = 0.001d;
                double p = minplog(rpy, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double proll = minplog(new double[] { rpy[0] + delta, rpy[1], rpy[2] }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double ppitch = minplog(new double[] { rpy[0], rpy[1] + delta, rpy[2] }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                double pyaw = minplog(new double[] { rpy[0], rpy[1], rpy[2] + delta }, rpyPrev, rpyPrevPrev, pitch, rmsLoudness);
                System.out.println("Diff: "
                        + Arrays.toString(new double[] { (proll - p) / delta, (ppitch - p) / delta, (pyaw - p) / delta }));
                System.out.println("P: " + p);
                // return new double[] { (proll - p) , (ppitch - p) , (pyaw - p) };
                return new double[] { (proll - p) / delta, (ppitch - p) / delta, (pyaw - p) / delta };
            }
        };
        return GradientDescent.optimize(f, rpyPrev, 0.02d, 0.002d, 100);
    }
}
