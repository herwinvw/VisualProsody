package visualprosody;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import org.junit.Before;
import org.junit.Test;

import visualprosody.GaussianMixtureModel2.GaussianMixture;

import com.google.common.collect.ImmutableList;

/**
 * Unit tests for VisualProsodyLe
 * @author herwinvw
 *
 */
public class VisualProsodyLeTest
{
    private GaussianMixtureModel2 mockGmmVelocity = mock(GaussianMixtureModel2.class);
    private GaussianMixtureModel2 mockGmmAcceleration = mock(GaussianMixtureModel2.class);
    private static final double PRECISION = 0.1;

    private GaussianMixture gmRollVoiced = new GaussianMixture(1, new MVGaussian(new double[] { -2, 1, 1 }, new double[][] { { 1, 0, 0 },
            { 0, 1, 0 }, { 0, 0, 1 } }));
    private GaussianMixture gmPitchVoiced = new GaussianMixture(1, new MVGaussian(new double[] { 0, 1, 1 }, new double[][] { { 1, 0, 0 },
            { 0, 1, 0 }, { 0, 0, 1 } }));
    private GaussianMixture gmYawVoiced = new GaussianMixture(1, new MVGaussian(new double[] { 2, 1, 1 }, new double[][] { { 1, 0, 0 },
            { 0, 1, 0 }, { 0, 0, 1 } }));

    private GaussianMixture gmRollUnvoiced = new GaussianMixture(1, new MVGaussian(new double[] { 2, 1 }, new double[][] { { 1, 0 },
            { 0, 1 }, }));
    private GaussianMixture gmPitchUnvoiced = new GaussianMixture(1, new MVGaussian(new double[] { 0, 1 }, new double[][] { { 1, 0 },
            { 0, 1 } }));
    private GaussianMixture gmYawUnvoiced = new GaussianMixture(1, new MVGaussian(new double[] { -2, 1 }, new double[][] { { 1, 0 },
            { 0, 1 } }));

    private GaussianMixture gmVelocityVoiced = new GaussianMixture(1, new MVGaussian(new double[] { 1, 1, 1 }, new double[][] {
            { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 } }));
    private GaussianMixture gmVelocityUnvoiced = new GaussianMixture(1, new MVGaussian(new double[] { 1, 1 }, new double[][] { { 1, 0 },
            { 0, 1 } }));

    private GaussianMixture gmAccelerationVoiced = new GaussianMixture(1, new MVGaussian(new double[] { 3, 1, 1 }, new double[][] {
            { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 } }));
    private GaussianMixture gmAccelerationUnvoiced = new GaussianMixture(1, new MVGaussian(new double[] { 3, 1 }, new double[][] {
            { 1, 0 }, { 0, 1 } }));

    private VisualProsodyLe vpNoVellAcc;
    private VisualProsodyLe vpNoAcc;
    private VisualProsodyLe vp;

    @Before
    public void setup()
    {
        when(mockGmmVelocity.P(any(double[].class))).thenReturn(1d);
        when(mockGmmVelocity.logPDiff1(any(double[].class))).thenReturn(0d);
        when(mockGmmAcceleration.P(any(double[].class))).thenReturn(1d);
        vpNoVellAcc = new VisualProsodyLe(new GaussianMixtureModel2(ImmutableList.of(gmRollVoiced)), new GaussianMixtureModel2(
                ImmutableList.of(gmPitchVoiced)), new GaussianMixtureModel2(ImmutableList.of(gmYawVoiced)), mockGmmVelocity,
                mockGmmAcceleration, new GaussianMixtureModel2(ImmutableList.of(gmRollUnvoiced)), new GaussianMixtureModel2(
                        ImmutableList.of(gmPitchUnvoiced)), new GaussianMixtureModel2(ImmutableList.of(gmYawUnvoiced)), mockGmmVelocity,
                mockGmmAcceleration);
        vpNoAcc = new VisualProsodyLe(new GaussianMixtureModel2(ImmutableList.of(gmRollVoiced)), new GaussianMixtureModel2(
                ImmutableList.of(gmPitchVoiced)), new GaussianMixtureModel2(ImmutableList.of(gmYawVoiced)), new GaussianMixtureModel2(
                ImmutableList.of(gmVelocityVoiced)), mockGmmAcceleration, new GaussianMixtureModel2(ImmutableList.of(gmRollUnvoiced)),
                new GaussianMixtureModel2(ImmutableList.of(gmPitchUnvoiced)), new GaussianMixtureModel2(ImmutableList.of(gmYawUnvoiced)),
                new GaussianMixtureModel2(ImmutableList.of(gmVelocityUnvoiced)), mockGmmAcceleration);
        vp = new VisualProsodyLe(new GaussianMixtureModel2(ImmutableList.of(gmRollVoiced)), new GaussianMixtureModel2(
                ImmutableList.of(gmPitchVoiced)), new GaussianMixtureModel2(ImmutableList.of(gmYawVoiced)), new GaussianMixtureModel2(
                ImmutableList.of(gmVelocityVoiced)), new GaussianMixtureModel2(ImmutableList.of(gmAccelerationVoiced)),
                new GaussianMixtureModel2(ImmutableList.of(gmRollUnvoiced)), new GaussianMixtureModel2(ImmutableList.of(gmPitchUnvoiced)),
                new GaussianMixtureModel2(ImmutableList.of(gmYawUnvoiced)),
                new GaussianMixtureModel2(ImmutableList.of(gmVelocityUnvoiced)), new GaussianMixtureModel2(
                        ImmutableList.of(gmAccelerationUnvoiced)));
    }

    @Test
    public void testUnVoicedNoVelAccAtMaximum()
    {
        double res[] = vpNoVellAcc.generateHeadPose(new double[] { 2, 0, -2 }, new double[] { 2, 0, -2 }, new double[] { 2, 0, -2 }, 0, 1);
        assertEquals(2, res[0], PRECISION);
        assertEquals(0, res[1], PRECISION);
        assertEquals(-2, res[2], PRECISION);
    }
    
    @Test
    public void testUnVoicedNoVelAcc()
    {
        double res[] = vpNoVellAcc.generateHeadPose(new double[] { 0, 3, 0 }, new double[] { 0, 3, 0 }, new double[] { 0, 3, 0 }, 0, 1);
        assertEquals(2, res[0], PRECISION);
        assertEquals(0, res[1], PRECISION);
        assertEquals(-2, res[2], PRECISION);
    }
    
    @Test
    public void testVoicedNoVelAcc()
    {
        double res[] = vpNoVellAcc.generateHeadPose(new double[] { 0, 3, 0 }, new double[] { 0, 3, 0 }, new double[] { 0, 2.99, 0 }, 1, 1);
        assertEquals(-2, res[0], PRECISION);
        assertEquals(0, res[1], PRECISION);
        assertEquals(2, res[2], PRECISION);
    }    

    @Test
    public void testVoicedVelNoAcc()
    {
        double res[] = vpNoAcc.generateHeadPose(new double[] { -2, 1, 2 }, new double[] { -2, 1, 2 }, new double[] { -2, 0, 2 }, 1, 1);
        assertEquals(-2, res[0], PRECISION);
        assertEquals(0, res[1], PRECISION);
        assertEquals(2, res[2], PRECISION);
    }

    @Test
    public void testUnvoicedVelNoAcc()
    {
        double res[] = vpNoAcc.generateHeadPose(new double[] { 2, 1, -2 }, new double[] { 2, 1, -2 }, new double[] { -2, 0, 2 }, 0, 1);        
        assertEquals(2, res[0], PRECISION);
        assertEquals(0, res[1], PRECISION);
        assertEquals(-2, res[2], PRECISION);
    }

    @Test
    public void testVoicedVelAcc()
    {
        double res[] = vp.generateHeadPose(new double[] { -2, 1, 2 }, new double[] { -2, 1, 2 }, new double[] { -2, -1, 2 }, 1, 1);
        assertEquals(-2, res[0], PRECISION);
        assertEquals(0, res[1], PRECISION);
        assertEquals(2, res[2], PRECISION);
    }

    @Test
    public void testUnvoicedVelAcc()
    {
        double res[] = vp.generateHeadPose(new double[] { 2, 1, -2 },new double[] { 2, 1, -2 }, new double[] { 2, -1, -2 }, 0, 1);
        assertEquals(2, res[0], PRECISION);
        assertEquals(0, res[1], PRECISION);
        assertEquals(-2, res[2], PRECISION);
    }
}
