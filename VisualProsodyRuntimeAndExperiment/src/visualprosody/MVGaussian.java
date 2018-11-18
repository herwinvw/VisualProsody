package visualprosody;

import lombok.Getter;

import org.apache.commons.math3.linear.LUDecomposition;
import org.apache.commons.math3.linear.MatrixUtils;
import org.apache.commons.math3.linear.RealMatrix;

public class MVGaussian
{
    @Getter
    private final double sigma[][];
    
    private final RealMatrix sigmaInverse;
    
    @Getter
    private final double[] mu;
    
    private final double C;
    
    @Getter
    private final int K;

    public MVGaussian(double[] mu, double sigma[][])
    {
        this.mu = mu;
        this.sigma = sigma;
        K = mu.length;
        RealMatrix m = MatrixUtils.createRealMatrix(sigma);
        sigmaInverse = MatrixUtils.inverse(m);
        double sigmaDet = new LUDecomposition(m).getDeterminant();
        double c = Math.pow(2 * Math.PI, K) * sigmaDet;
        C = 1 / (Math.sqrt(c));
    }

    public double P(double[] x)
    {
        double xminmu[] = new double[K];
        for (int i = 0; i < K; i++)
        {
            xminmu[i] = x[i] - mu[i];
        }
        RealMatrix xMinusMu = MatrixUtils.createRowRealMatrix(xminmu);
        RealMatrix xMinusMuT = MatrixUtils.createColumnRealMatrix(xminmu);
        RealMatrix m = xMinusMu.multiply(sigmaInverse);
        m = m.multiply(xMinusMuT);
        return C * Math.exp(-0.5 * m.getData()[0][0]);
    }
    
    /**
     * Get the partial derivative of the Gaussian dx[0]/dP  
     */
    public double Pdiff1(double []x)
    {
        double xminmu[] = new double[K];
        double res = 0;
        for (int i = 0; i < K; i++)
        {
            xminmu[i] = x[i] - mu[i];
            res -= sigmaInverse.getEntry(0, i)*xminmu[i];
        }        
        return res*P(x);                
    }
}
