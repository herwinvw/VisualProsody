package visualprosody;

import static org.junit.Assert.assertEquals;

import org.apache.commons.math3.distribution.MultivariateNormalDistribution;
import org.junit.Test;
import static org.hamcrest.number.OrderingComparison.greaterThan;
import static org.hamcrest.number.OrderingComparison.lessThan;
import static org.hamcrest.MatcherAssert.assertThat;

/**
 * Unit tests for MVGaussian
 * @author herwinvw
 *
 */
public class MVGaussianTest
{
    private static final double PRECISION = 0.00001;

    @Test
    public void test1()
    {
        double[] mu = new double[] { 2 };
        double[][] sigma = new double[][] { { 1 } };
        MVGaussian mvg = new MVGaussian(mu, sigma);
        MultivariateNormalDistribution mvgExp = new MultivariateNormalDistribution(mu, sigma);
        assertEquals(mvgExp.density(new double[] { 2 }), mvg.P(new double[] { 2 }), PRECISION);
    }

    @Test
    public void test2()
    {
        double[] mu = new double[] { 2, 1 };
        double[][] sigma = new double[][] { { 1, 0 }, { 0, 1 } };
        MVGaussian mvg = new MVGaussian(mu, sigma);
        MultivariateNormalDistribution mvgExp = new MultivariateNormalDistribution(mu, sigma);
        assertEquals(mvgExp.density(new double[] { 2, 1 }), mvg.P(new double[] { 2, 1 }), PRECISION);
    }

    @Test
    public void testDiffShape1()
    {
        double[] mu = new double[] { 2 };
        double[][] sigma = new double[][] { { 1 } };
        MVGaussian mvg = new MVGaussian(mu, sigma);
        assertEquals(0, mvg.Pdiff1(new double[] { 2 }), PRECISION);
        assertThat(mvg.Pdiff1(new double[] { 1 }), greaterThan(0d));
        assertThat(mvg.Pdiff1(new double[] { 3 }), lessThan(0d));
    }

    @Test
    public void testDiffShape3()
    {
        double[] mu = new double[] { 1, 2, 3 };
        double[][] sigma = new double[][] { { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 } };
        MVGaussian mvg = new MVGaussian(mu, sigma);
        assertEquals(0, mvg.Pdiff1(new double[] { 1, 2, 3 }), PRECISION);
        assertThat(mvg.Pdiff1(new double[] { 0.5d, 1d, 2d }), greaterThan(0d));
        assertThat(mvg.Pdiff1(new double[] { 2, 3, 4 }), lessThan(0d));
    }

    @Test
    public void testMatchWithNumerical()
    {
        double[] mu = new double[] { 1, 2, 3 };
        double[][] sigma = new double[][] { { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 } };
        MVGaussian mvg = new MVGaussian(mu, sigma);
        double dt = 0.001d;
        double dp = (mvg.P(new double[] { 4 + dt, 5, 6 }) - mvg.P(new double[] { 4, 5, 6 })) / dt;
        assertEquals(dp, mvg.Pdiff1(new double[] { 4, 5, 6 }), PRECISION);
    }
}
