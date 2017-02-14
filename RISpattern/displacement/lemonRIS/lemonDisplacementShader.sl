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
		float mag1;
		//noise the surface once
		mag1=abs(float noise(P*2,3));
		
		//on the top of the previous noised surface add this noise level
		//mag+=abs(float noise(P*60,60))/200;
		
		float currnetUVColor=texture("lemondots.tx",u,v);
		//..and so on
		//if (currnetUVColor<0.1)
		{
			float frame=5;
			//mag-=abs(float noise(P*80,frame*20)-0.5)/80;
		}
		
		
		//mag+=abs(float noise(P*2,2)-0.5)/15;
		//mag+=abs(float noise(P*150,150)-0.5)/15;

			//scale the displacement in object space, hence mag is now relative to this space
			//mag /= length(vtransform("object",NN));
			
		
		
		
		
		
		


point PP = transform("shader",P);

float dist;
float ss,tt;
float inDisk;
point centre;
point here;
float mag2;
float fuzz=0.025;


//float Km=0.1;
//float Layers=6;
//
//// init the shader values
//vector NN=normalize(N);
//float i;
//float mag=0;
//point Pt=transform("shader",P);
//for(i=0; i<Layers; i+=1)
//{
//mag+=(float noise(Pt*Freq)-0.5)*2/Freq;
//Freq*=2;
//}
//mag /=length(vtransform("object",NN));
//P=P+mag*NN*Km;
//N=calculatenormal(P);


//TURBULENCE TEST
float Km = 1.0;
string displace_map="lemondots.tx";
float swidth=0.0001;
float twidth=0.0001;
float samples=200;

float magnitude = 0;
float level = 0;

level =  texture(displace_map,s,t,
					"swidth", swidth,
					"twidth",twidth,
					"samples", samples);
// calculate the displacement
magnitude = ((level * 2) - 1) * Km;


float bigporesmag=0;
/* Calculate Big Pores on the Surface */
if (t>0.09)
{
	ss=mod(s*90+(0.9*noise(PP)+0.1),1);
	tt=mod(t*90+(0.9*noise(PP)+0.1),1);
    centre=point (0.5,0.5,0);
	here=point(ss,tt,0);
    dist=distance(centre,here)+(0.1*(noise(PP*50)/0.2));
    inDisk=1-smoothstep(-0.5,(0.25*noise(PP))+0.2,dist);
    bigporesmag=mix(0,1,inDisk);  
	bigporesmag /= length(vtransform("object",NN));
}
else
{
bigporesmag=0;
}



/* Calculate  Pores on the Surface */
//if (t>0.09)
{
	ss=mod(s*95+(0.95*noise(PP)),1);
	tt=mod(t*95+(0.95*noise(PP)),1);
    centre=point (0.5,0.5,0);
	here=point(ss,tt,0);
    dist=distance(centre,here)+(0.70*(noise(PP*10)/0.2));
    inDisk=1-smoothstep(-0.5,(0.5*noise(PP))+0.25,dist);
    mag2=mix(0,1,inDisk);  
	mag2 /= length(vtransform("object",NN));
}


//else
//{
//mag2=0;
//}


float mag3=0;
float i=0;
float freq=1;
/* Calculate minute pores on the surface */
for(i=0;i<4;i+=1)
        {
		mag3+=abs(float noise(PP*freq*1.8)-1)*1.3/freq*freq;
        freq*=5;
		}
	mag3 /= length(vtransform("object",NN));



///* Calculate minute pores on the surface */
//
//	for(i=0;i<6;i+=1)
//        {
//		mag2+=abs(float noise(PP*freq)-0.5)*2/freq;
//        freq*=3;
//		}
//	mag2 /= length(vtransform("object",NN));
//
///* Calculate the minute cellular surface pattern */
//
//	t_mag=0;
//	t_mag=mix(0,0.4,float noise(PP*85));
//	inSpot=smoothstep(0.3-0.3,0.7+0.3,t_mag);
//	disp=smoothstep(0,1.25,inSpot);//
//	mag3=disp;
//
///* Calculate the larger cellular surface pattern */
//
//	t_mag=0;
//	t_mag=mix(0,0.4,float noise(PP*30));
//	inSpot=smoothstep(0.3-0.3,0.7+0.3,t_mag);
//	disp=smoothstep(0,1.85,inSpot);
//	mag5=disp;
//
//
///* Calculate the overall deformation of the object */
//
//    for(i=0;i<6;i+=1)
//        {
//		mag4+=abs(float noise(PP*freq1)-0.5)*2/freq1;
//        freq1*=1.25;
//		}
//	mag4 /= length(vtransform("object",NN));
//		

		
	/* Calculating the top dent */

	float Top = smoothstep(0.01,0.1 ,t);
	float mag6 = mix(0,1,Top);
	
	
	/* Calculating the middle / right after top dent */
	float middleTop = smoothstep(0.1,0.2 ,t);
	float middleTopDentBump = mix(0,1,middleTop);


	/* Calculating the middle / right before bottom dent */
	float middleBottom = smoothstep(0.5,0.92 ,t);
	float middlBottomDentBump = mix(0,1,middleBottom);

	/* Calculating the bottom dent */

	float Bottom = smoothstep(0.92,0.97+ 0.025*noise(PP)-0.005,t);
	float mag8 = mix(0,1,Bottom);
	


	/* Calculate top and bottom creases of the surface */
        float cutsInAxis=1;
		ss=mod(s*3,1);
		tt=mod((1-t)*cutsInAxis,1);
		centre=point (0.5,0.5,0);
		here=point (ss,tt,0);
		dist=distance(centre,here);
		
		inDisk=1-smoothstep(-0.1, 0.9+(noise(PP*30)/50), dist);
		

		float mag7=mix(0,-1,inDisk)-mix(noise(PP*5),-1,Top)*t;
		
   
		
		
		
	float mag=(mag1*-0.12)+(mag2*-0.002)+(bigporesmag*-0.02)+ (mag3*-0.0008)  +(mag6*-0.11)+(middleTopDentBump*-0.01)+(middlBottomDentBump*0.1)+ (mag7*-0.02)+(mag8*0.08) + (magnitude*-0.001); //+(mag3*-0.055)+(mag4*0.2)+(mag5*-0.2)+(mag6*0.15)+(mag7*-0.1)+(mag8*-0.15);

		
		
		P=P+(mag)*NN; 
		
		//re-calc the normal
		N=calculatenormal(P);
    }

    public void lighting(output color Ci, Oi)
    {
        Ci = 1.0;
        Oi = 1.0;
    }
}



