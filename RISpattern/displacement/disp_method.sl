class
disp_method(float disp = 0.25; float atten = 0.5)
{
    public void displacement(output point P; output normal N)
    {
        point PP = transform ("shader", P);
        
        //grab the normal in shader space
        //https://renderman.pixar.com/resources/current/RenderMan/rslGuidelines97.html
        normal sN = normalize(ntransform("shader",N));
        
        float scale;
        
        //assing the data from the dipl input parameter to scale variable
        evalparam("disp",scale);
        
        //transform point along normal in shader space
        P = transform("shader","current",PP + sN*scale*atten);
        
        //calculate new transformed point normal, so as to do proper lighting
        N = calculatenormal(P);
    }

    public void lighting(output color Ci, Oi)
    {
        Ci = 1.0;
        Oi = 1.0;
    }
}

