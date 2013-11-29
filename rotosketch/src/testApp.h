#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxSimpleSlider.h"
#include "ofxUI.h"




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
        
        if (line.getVertices().size() < 3) return;
        
        //ofSetColor(0,0,0);
        ofVboMesh meshy;
        meshy.setMode(OF_PRIMITIVE_TRIANGLE_STRIP);
        
        //float widthSmooth = 10;
        //float angleSmooth = 0;
        
        float startAngle;
        float endAngle;
        ofPoint startPos;
        ofPoint endPos;
        
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
            
            if (i == 0) startAngle = angle;
            if (i == line.getVertices().size()-1) endAngle = angle;
            if (i == 0) startPos = line.getVertices()[i];
            if (i == line.getVertices().size()-1) endPos = line.getVertices()[i];
            
        }
        meshy.draw();
        
        startAngle -= PI/2.0;
        
        meshy.clear();
        meshy.setMode(OF_PRIMITIVE_TRIANGLE_FAN);
        meshy.addVertex(startPos);
        for (int i = 0; i < 20; i++){
            float angle = ofMap(i,0,19, startAngle, startAngle-PI);
            meshy.addVertex(startPos + thickness * ofPoint(cos(angle), sin(angle)));
        }
        
        meshy.draw();
        
        endAngle -= PI/2.0;
        meshy.clear();
        meshy.setMode(OF_PRIMITIVE_TRIANGLE_FAN);
        meshy.addVertex(endPos);
        for (int i = 0; i < 20; i++){
            float angle = ofMap(i,0,19, endAngle, endAngle+PI);
            meshy.addVertex(endPos + thickness * ofPoint(cos(angle), sin(angle)));
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
        
        
        ofPolyline line;
        
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
                
                //cout << "i: " << i << " " << endl;
                if (bPtBGood == true && bPtBGood == true){
                    line.addVertex(timePts[i].pt);
                    //cout << "------>  good: " << line.size() << endl;
                    //ofLine(timePts[i].pt, timePts[i+1].pt);
                    if (i == timePts.size()-2){
                        line.addVertex(timePts[i+1].pt);
                        drawPolyineThick(line, width);
                    }
                } else {
                    
                    ///cout << "------> non good: " << line.size() << endl;
                    //if (line.size() > 1) cout << line.size() << endl;
                    if (line.size() > 1) drawPolyineThick(line, width);
                    line.getVertices().clear();
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
    
    
        ofPoint drawingTimePos[10];
        bool bDrawingTimeStoke[10];
        timeStroke stroke[10];
        vector < timeStroke > strokes;
       // ofxSimpleSlider slider;

        ofxiPhoneVideoPlayer player;
        ofxiPhoneVideoPlayer playerSmall;
    
        ofFbo fbo;
    
        ofxUICanvas *gui;
        void guiEvent(ofxUIEventArgs &e);
    
    
    //-----
    
    ofxUISlider * sliderPosition;
    float position;
    float thickness;
    float transparency;
    bool bDrawMag;
    float movieSpeed;
    
    float howMuchT;
    
    
    ofColor backgroundColor;
    float radius;
    int resolution;
   // ofPoint position;
    bool drawFill;
	float red, green, blue, alpha;
    


};


