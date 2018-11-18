writeGMMToXML<-function(gmm,filename)
{
	library(XML)
	top <- newXMLNode("gmm", attrs=c(k=length(gmm$lambda)))
	lambdas <- newXMLNode("lambdas",parent=top)
	for (lambda in gmm$lambda)
	{
		newXMLNode("lambda",attrs=c(val=lambda), parent=lambdas)
	}
	mus<-newXMLNode("mus",parent=top)
	for (mu in gmm$mu)
	{
		newXMLNode("mu",attrs=c(val=paste(mu,collapse=" ")),parent=mus)
	}
	sigmas<-newXMLNode("sigmas",parent=top)
	for (sigma in gmm$sigma)
	{
		newXMLNode("sigma",attrs=c(val=paste(sigma,collapse=" ")),parent=sigmas)
	}
	saveXML(top,file=filename)
}