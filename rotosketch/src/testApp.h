#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include "ofxSimpleSlider.h"



//-------------------------------------------------
class timePoint {
public:
    float time;
    ofPoint pt;
};


//-------------------------------------------------
class timeStroke {
public:
    
    vector < timePoint > timePts;
    
    float width;
    
    timeStroke(){
        width = 10;
        
    }
    
    void drawPolyineThick( ofPolyline & line, int thickness){
        
        ofSetColor(0,0,0);
        ofMesh meshy;
        meshy.setMode(OF_PRIMITIVE_TRIANGLE_STRIP);
        
        float widthSmooth = 10;
        float angleSmooth;
        
        for (int i = 0;  i < line.getVertices().size(); i++){
            int me_m_one = i-1;
            int me_p_one = i+1;
            if (me_m_one < 0) me_m_one = 0;
            if (me_p_one ==  line.getVertices().size()) me_p_one =  line.getVertices().size()-1;
            ofPoint diff = line.getVertices()[me_p_one] - line.getVertices()[me_m_one];
            float angle = atan2(diff.y, diff.x);
            float dist = diff.length();
            ofPoint offset;
            offset.x = cos(angle + PI/2) * thickness;
            offset.y = sin(angle + PI/2) * thickness;
            meshy.addVertex(  line.getVertices()[i] +  offset );
            meshy.addVertex(  line.getVertices()[i] -  offset );
        }
        
        meshy.draw();
        
        
    }
    
    
    
    void draw(){
        
        ofNoFill();
        ofSetColor(255,255,255);
        ofBeginShape();
        for (int i = 0; i < timePts.size(); i++){
            ofVertex(timePts[i].pt.x, timePts[i].pt.y);
        }
        ofEndShape();
    }
    
    
    void draw(float time, float distanceFromTime, float totalTime){
        
        
        // this is simpler logic!
        
        float startTime = time - distanceFromTime;
        
        if (timePts.size() > 1){
            
            for (int i = 0; i < timePts.size()-1; i++){
                
                bool bPtaGood = false;
                bool bPtBGood = false;
                
                
                
                if (timePts[i].time >= startTime && timePts[i].time <= time){
                    bPtaGood = true;
                }
                
                if (timePts[i+1].time >= startTime && timePts[i+1].time <= time){
                    bPtBGood = true;
                }
                
                if (startTime < 0){
                    if (timePts[i].time >= (startTime + totalTime)  && timePts[i].time <= totalTime){
                        bPtaGood = true;
                    }
                    
                    if (timePts[i+1].time >= (startTime + totalTime)  && timePts[i+1].time <= totalTime){
                        bPtBGood = true;
                    }
                }
                
                if (bPtBGood == true && bPtBGood == true){
                    ofLine(timePts[i].pt, timePts[i+1].pt);
                }
            }
            
            
            
        }
    }
    
    
    void clear(){ timePts.clear(); };
    
    void addVertex(ofPoint pt, float t){
        timePoint ptTemp;
        ptTemp.pt = pt;
        ptTemp.time = t;
        timePts.push_back(ptTemp);
    }
    
};

class testApp : public ofxiOSApp{
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
    
    
        timeStroke stroke[10];
        vector < timeStroke > strokes;
        ofxSimpleSlider slider;


};


