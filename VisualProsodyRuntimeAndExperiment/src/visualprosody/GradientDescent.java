package visualprosody;

import java.util.Arrays;

public final class GradientDescent
{
    public static interface Function
    {
        public double[] evaluateDiff(double x[]);
    }

    public static double[] optimize(Function f, double[] start, double stepSize, double precision, int maxSteps)
    {
        double[] x = new double[start.length];
        double[] xprev = new double[start.length];
        double sqPrecision = precision * precision;
        for (int i = 0; i < start.length; i++)
        {
            x[i] = start[i];
            xprev[i] = start[i];
        }

        for (int i = 0; i < maxSteps; i++)
        {
            System.out.println("iteration: "+i);
            System.out.println("x: "+Arrays.toString(x));
            double diff[] = f.evaluateDiff(x);
            for (int j = 0; j < start.length; j++)
            {
                xprev[j] = x[j];
                x[j] = x[j] - stepSize * diff[j];
            }

            double sqDist = 0;
            for (int j = 0; j < start.length; j++)
            {
                sqDist += (x[j] - xprev[j]) * (x[j] - xprev[j]);
            }
            System.out.println("dist: "+Math.sqrt(sqDist));
            if (sqDist < sqPrecision)
            {
                break;
            }
        }        
        return x;
    }
}
