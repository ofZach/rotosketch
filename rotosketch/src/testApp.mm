#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	

    
    ofSetOrientation(OF_ORIENTATION_90_RIGHT);
    
    
    player.loadMovie("video/dance.mov");
    player.play();
    
    playerSmall.loadMovie("video/dance.mov");
    playerSmall.setPaused(true);
    
    
    player.setLoopState(OF_LOOP_NORMAL);
    playerSmall.setLoopState(OF_LOOP_NORMAL);
    
    //slider.setup ( 100, 650, 300, 30, 0, 1.0, 0.0, false, true);
    
    
    fbo.allocate(ofGetWidth(), ofGetHeight()-150);
    
    
    
    float dim = 32;
    
    movieSpeed = 1;
    position = 0;
    thickness = 10;
    transparency = 1.0;

    howMuchT = 0.01;
    bDrawMag = false;
    
    gui = new ofxUICanvas(0,ofGetHeight()-150, ofGetWidth(), 150);
    
    gui->setWidgetPosition(OFX_UI_WIDGET_POSITION_DOWN);
    sliderPosition = gui->addSlider("movie position", 0,1.0, position, 195, dim);
    gui->addSlider("movie speed", -3,3, &movieSpeed, 195, dim);

    gui->setWidgetPosition(OFX_UI_WIDGET_POSITION_RIGHT);
    gui->addSlider("thickness", 1, 20, &thickness, 95, dim);
    gui->addSlider("transparency", 0, 1.0, &transparency, 95, dim);
    
    gui->addSlider("how much time", 0, 0.4, &howMuchT, 155, dim);
    
    gui->setWidgetPosition(OFX_UI_WIDGET_POSITION_RIGHT);
    gui->addToggle("clear", false);
    gui->addToggle("use mag", &bDrawMag);

    ofBackground(backgroundColor);
    
    gui->loadSettings("GUI/guiSettings.xml");
    
}

static bool hadFocus = false;

//--------------------------------------------------------------
void testApp::update(){

   // cout << sliderPosition->getPercentValue() << endl;
   // cout << sliderPosition->state << endl;
    
    
 
    if (hadFocus && !(sliderPosition->state == 2)){
        
        player.setPosition(sliderPosition->getValue());
        player.update();
        player.setPaused(false);
    }
    
//    if (!hadFocus && (sliderPosition->state == 2)){
//        
//        player.setPosition(sliderPosition->getValue());
//        player.update();
//    }

    
    
    
    
    if (!(sliderPosition->state == 2)){
        
        
        
        //cout << movieSpeed << endl;
        player.setSpeed(movieSpeed);
        cout << player.getSpeed() << endl;;
        sliderPosition->setValue(player.getPosition());
        player.update();
    } else {
        playerSmall.setPosition(sliderPosition->getPercentValue());
        playerSmall.update();
        player.setPaused(true);
        player.setPosition(sliderPosition->getPercentValue());
        
    }
    
    hadFocus = (sliderPosition->state == 2);
    
    
    
}

//--------------------------------------------------------------
void testApp::draw(){
	
   
    ofBackground(0,0,0);
    
    ofSetColor(255,255,255);
    
    ofRectangle rect(0,0,ofGetWidth(), ofGetHeight()-150);
    ofRectangle rect2(0,0,player.getWidth(), player.getHeight());
    
    rect2.scaleTo(rect);
    
    ofSetColor(ofColor::darkCyan);
    ofFill();
    ofRect(rect2.x, rect2.y + rect2.height, rect2.width, 150);
    
    ofSetColor(255,255,255);
    
    
    fbo.begin();
    ofClear(255,255,255);
    
    ofEnableAlphaBlending();
    ofSetColor(255,255,255,255*transparency);
    
    if (!(sliderPosition->state == 2)){
        player.getTexture()->draw(rect2.x, rect2.y, rect2.width, rect2.height);
    } else {
        playerSmall.getTexture()->draw(rect2.x, rect2.y, rect2.width, rect2.height);
    }
    
    float timeT = player.getPosition();
    if (sliderPosition->state == 2){
        timeT = sliderPosition->getPercentValue();
    }
    ofDrawBitmapStringHighlight(ofToString(timeT), 30,30);
    
    fbo.end();
    ofDisableAlphaBlending();
    ofSetColor(255,255,255);
    fbo.draw(0,0);
    
    
    
        ofSetColor(0,0,0);
    
    for (int i = 0; i < 10; i++){
        stroke[i].draw(timeT, howMuchT, 1.0);
    }
    for (int i = 0; i < strokes.size(); i++){
        strokes[i].draw(timeT, howMuchT, 1.0);
    }
    
    
    
   

    
    
    
    ofDisableAlphaBlending();
    ofSetColor(255,255,255);
    
    
    
    if (bDrawMag){
        
        
        
        for (int i = 0;  i < 10; i++){
            if (bDrawingTimeStoke[i]){
                ofSetColor(255,255,255,200);
                ofMesh mesh;
                mesh.setMode(OF_PRIMITIVE_TRIANGLE_FAN);
                for (int j = 0; j < 20; j++){
                    ofPoint pos( 80 * cos((j/19.0)*TWO_PI), 80 * sin((j/19.0)*TWO_PI));
                    mesh.addVertex( ofPoint(drawingTimePos[i].x,drawingTimePos[i].y - 60) + pos);
                    ofPoint posTex = ofPoint(drawingTimePos[i].x,drawingTimePos[i].y) + pos * 1.4;
                    mesh.addTexCoord(fbo.getTextureReference().getCoordFromPoint(posTex.x, posTex.y));
                }
                
                
                ofEnableAlphaBlending();
                fbo.getTextureReference().bind();
                mesh.draw();
                fbo.getTextureReference().unbind();
                
                ofDisableAlphaBlending();
                ofSetColor(255,255,255,255);
                ofNoFill();
                ofCircle(ofPoint(drawingTimePos[i].x,drawingTimePos[i].y - 60), 80);
                ofLine(ofPoint(drawingTimePos[i].x,drawingTimePos[i].y - 60) - ofPoint(20,0),
                       ofPoint(drawingTimePos[i].x,drawingTimePos[i].y - 60) + ofPoint(20,0));
                
                ofLine(ofPoint(drawingTimePos[i].x,drawingTimePos[i].y - 60) - ofPoint(0,20),
                       ofPoint(drawingTimePos[i].x,drawingTimePos[i].y - 60) + ofPoint(0,20));
                
            }
        }
        
        
        
    }
    
   // slider.draw();
    
    
   
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){

    
    if ( touch.y < ofGetHeight()-150){
        bDrawingTimeStoke[touch.id] = true;
        drawingTimePos[touch.id].set(touch.x, touch.y);
        stroke[touch.id].width = thickness;
    } else {
        bDrawingTimeStoke[touch.id] = false;
    }
    
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

    
    if (bDrawingTimeStoke[touch.id]){
        drawingTimePos[touch.id].set(touch.x, touch.y);
        
        float timeT = player.getPosition();
        stroke[touch.id].addVertex(ofPoint(touch.x,touch.y), timeT);
    }

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

     if (bDrawingTimeStoke[touch.id]){
         strokes.push_back( stroke[touch.id]);
         stroke[touch.id].clear();
         drawingTimePos[touch.id].set(touch.x, touch.y);
         
     }

     bDrawingTimeStoke[touch.id] = false;
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

//--------------------------------------------------------------
void testApp::guiEvent(ofxUIEventArgs &e)
{
	
}
