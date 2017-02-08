class
lemonDisplacementShader(float disp = 0.25; float atten = 0.5)
{
    public void displacement(output point P; output normal N)
    {
		//ferrero shader
        //point PP = transform ("shader", P);
        
        //grab the normal in shader space
        //https://renderman.pixar.com/resources/current/RenderMan/rslGuidelines97.html
        //normal sN = normalize(ntransform("shader",N));
        
        float scale;
        
        //assing the data from the dipl input parameter to scale variable
        evalparam("disp",scale);
       
        
        //transform point along normal in shader space
        //P = transform("shader","current",PP + sN*scale*atten);
        
        //calculate new transformed point normal, so as to do proper lighting
        //N = calculatenormal(P);
        
       
        //LEMON shader
        normal NN=normalize(N);
		float mag;
		//noise the surface once
		mag=abs(float noise(P*0.6)-0.9);
		
		//on the top of the previous noised surface add this noise level
		mag+=abs(float noise(P*50,50*2)-0.5)/35;
		
		float currnetUVColor=texture("outSide.tx",u,v);
		//..and so on
		//if (currnetUVColor<0.1)
		{
			float frame=5;
			mag-=abs(float noise(P*80,frame*20)-0.5)/80;
		}
		
		
		//mag+=abs(float noise(P*2,2)-0.5)/15;
		//mag+=abs(float noise(P*200,200)-0.5)/15;

			//scale the displacement in object space, hence mag is now relative to this space
			mag /= length(vtransform("object",NN));
			
		
		
		P=P+(mag*disp*atten)*NN; //
		
		N=calculatenormal(P);
    }

    public void lighting(output color Ci, Oi)
    {
        Ci = 1.0;
        Oi = 1.0;
    }
}



