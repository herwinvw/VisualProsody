package visualprosody;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import visualprosody.GaussianMixtureModel2.GaussianMixture;

import com.google.common.collect.ImmutableList;

/**
 * Unit tests for the GaussianMixture
 * @author herwinvw
 *
 */
public class GaussianMixtureModel2Test
{
    private static final double PRECISION = 0.00001d;

    @Test
    public void testOneGaussianOneDimension()
    {
        GaussianMixture gm = new GaussianMixture(1, new MVGaussian(new double[] { 0 }, new double[][] { { 1 } }));
        GaussianMixtureModel2 gmm = new GaussianMixtureModel2(ImmutableList.of(gm));
        assertEquals(1 / Math.sqrt(2 * Math.PI), gmm.P(new double[] { 0 }), PRECISION);
    }

    @Test
    public void testOneGaussianTwoDimensions()
    {
        GaussianMixture gm = new GaussianMixture(1, new MVGaussian(new double[] { 0, 1 }, new double[][] { { 1, 0 }, { 0, 1 } }));
        GaussianMixtureModel2 gmm = new GaussianMixtureModel2(ImmutableList.of(gm));
        assertEquals(1 / (2 * Math.PI), gmm.P(new double[] { 0, 1 }), PRECISION);
    }

    @Test
    public void testTwoGaussiansOneDimension()
    {
        GaussianMixture gm1 = new GaussianMixture(0.7, new MVGaussian(new double[] { 10 }, new double[][] { { 1 } }));
        GaussianMixture gm2 = new GaussianMixture(0.3, new MVGaussian(new double[] { -10 }, new double[][] { { 1 } }));
        GaussianMixtureModel2 gmm = new GaussianMixtureModel2(ImmutableList.of(gm1, gm2));
        assertEquals(0.7 / Math.sqrt(2 * Math.PI), gmm.P(new double[] { 10 }), PRECISION);
        assertEquals(0.3 / Math.sqrt(2 * Math.PI), gmm.P(new double[] { -10 }), PRECISION);
    }

    @Test
    public void testMinLogPDiff1()
    {
        GaussianMixture gm = new GaussianMixture(1, new MVGaussian(new double[] { 0, 1 }, new double[][] { { 1, 0 }, { 0, 1 } }));
        GaussianMixtureModel2 gmm = new GaussianMixtureModel2(ImmutableList.of(gm));
        double dx = 0.001;
        double pdiff = (gmm.logPDiff1(new double[] { 1 + dx, 2 }) - gmm.logPDiff1(new double[] { 1, 2 })) / dx;
        assertEquals(pdiff, gmm.logPDiff1(new double[] { 1, 2 }), PRECISION);
    }
}
