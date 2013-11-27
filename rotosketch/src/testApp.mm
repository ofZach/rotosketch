#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	

}

//--------------------------------------------------------------
void testApp::update(){

}

//--------------------------------------------------------------
void testApp::draw(){
	
    ofBackground(0,0,0);
    
    float timeT = ofGetElapsedTimef();
    while (timeT > 5) timeT -= 5.0;
    ofDrawBitmapStringHighlight(ofToString(timeT), 30,30);
    
    
    
    ofSetColor(255,255,255);
    
    for (int i = 0; i < 10; i++){
        stroke[i].draw(timeT, 1, 5);
    }
    for (int i = 0; i < strokes.size(); i++){
        strokes[i].draw(timeT, 1, 5);
    }

}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){

    
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

    float timeT = ofGetElapsedTimef();
    while (timeT > 5) timeT -= 5.0;
    stroke[touch.id].addVertex(ofPoint(touch.x,touch.y), timeT);

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

    strokes.push_back( stroke[touch.id]);
     stroke[touch.id].clear();
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}
