package visualprosody;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

/**
 * Unit tests for GradientDescent
 * @author herwinvw
 *
 */
public class GradientDescentTest
{
    private static final double PRECISION = 0.001d;

    @Test
    public void testXSquare()
    {
        // f=x^2, f'(x)=2x, minimum = 0
        GradientDescent.Function f = new GradientDescent.Function()
        {
            @Override
            public double[] evaluateDiff(double[] x)
            {
                return new double[] { 2 * x[0] };
            }
        };
        assertEquals(0, GradientDescent.optimize(f, new double[] { 10 }, 0.7d, PRECISION, 1000)[0], PRECISION);
    }

    @Test
    public void testXSquareTwoDimensional()
    {
        // f1=x^2, f'(x)=2x, minimum = 0
        // f2=(x+1)^2 f'(x)=2(x+1), minimum = -1
        GradientDescent.Function f = new GradientDescent.Function()
        {
            @Override
            public double[] evaluateDiff(double[] x)
            {
                return new double[] { 2 * x[0], 2 * (x[1] + 1) };
            }
        };
        double res[] = GradientDescent.optimize(f, new double[] { 10, -5 }, 0.7d, PRECISION, 1000);
        assertEquals(0, res[0], PRECISION);
        assertEquals(-1, res[1], PRECISION);
    }
}
