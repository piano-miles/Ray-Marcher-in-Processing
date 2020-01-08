float x = 0;
float y = 0;
float z = 0;
float DE = 0;
float normalize = 0;
int intersect = 0;
int iterations = 0;
float w = 0;
float h = 0;
float yoff = 0;
float zDepth = 0;
float dx = 0;
float dy = 0;
float dz = 0;
float maxDepth = 0;
color out = 0;
int samples = 4;
float sub = 0;
int itersub = 0;
PVector light;
PVector normal;
float diffuse = 0;

void setup() {
  light = new PVector(1, 2, 3);
  light.div(light.mag());
  normal = new PVector(0, 0, 1);
  size(512, 512);
  smooth();
  frameRate(30);
  background(50, 0, 0);
  w = float(width);
  h = float(height);
  colorMode(HSB, 100);
}

void draw() {
  for (int i=0; i<width; i++) {
    loadPixels();
    for (int j=0; j<height; j++) {
      sub = 0;
      itersub = 0;
      for (int k=0; k<samples; k++) {
        x = ((float(i)+random(-0.5, 0.5))/w)-0.5;
        y = ((float(j)+random(-0.5, 0.5))/h)-0.5;
        z = 0.5;
        normalize = dist(x, y, z, 0, 0, 0);
        x = x/normalize;
        y = y/normalize;
        z = z/normalize;
        dx = x;
        dy = y;
        dz = z;
        intersect = 0;
        iterations = 0;
        zDepth = 0;
        while (iterations<129 && intersect == 0) { 
          DE = 0.99*(dist(((abs(x)+1.5)%3) - 1.5, ((abs(y-yoff)+1.5)%3) - 1.5, ((abs(z)+1.5)%3) - 1.5, 0, 0, 2)-1);
          x += (dx*DE);
          y += (dy*DE);
          z += (dz*DE);
          iterations++;
          zDepth += DE;
          if (DE<0.01) {
            intersect = 1;
          }
        }
        if (zDepth > maxDepth) {
          maxDepth = zDepth;
        }
        normal.set( (x/abs(x))*(((abs(x)+1.5)%3) - 1.5), (z/abs(z))*(((abs(x)+1.5)%3) +.5), ((y-yoff)/abs(y-yoff))*(((abs(y-yoff)+1.5)%3) - 1.5));
        diffuse = dist(normal.x, normal.y, normal.z, light.x, light.y, light.z);
        //sub += (100*(1-(zDepth/maxDepth)))/samples;
        //itersub += iterations;
        //sat = map(float(itersub)/samples, 0, 128, 0, 100);
      }
      println(float(round(diffuse*100))/100);
      //out = color(0, diffuse, diffuse-20 + diffuse);
      //if (i == 0 || j == 0) {
      //  pixels[i + (j*width)] = out;
      //} else {
      //pixels[width-i + ((height-j)*width)] = out;
      //pixels[i + ((height-j)*width)] = out;
      //pixels[width-i + (j*width)] = out;
      pixels[i + (j*width)] = out;
      //}
    }
    updatePixels();
  }
  noLoop();
}
