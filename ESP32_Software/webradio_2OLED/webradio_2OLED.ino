// inspirated by the AZ-Delivery Blog and modified with joy by
// mancas@lug-saar.de

#include <WiFi.h> 
//Includes from ESP8266audio
#include "AudioFileSourceICYStream.h" //input stream
#include "AudioFileSourceBuffer.h"    //input buffer
#include "AudioGeneratorMP3.h"        //decoder
#include "AudioOutputI2S.h"           //output stream

//library for OLECD display
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

//library for rotary encoder
#include "AiEsp32RotaryEncoder.h"
//esp32 library to save preferences in flash
#include <Preferences.h>

//WLAN access fill with your credentials

#define SSID1 "1111"
#define PSK1  "1111"
#define SSID2 "2222"
#define PSK2  "2222"


//used pins for rotary encoder
#define ROTARY_ENCODER_A_PIN 33
#define ROTARY_ENCODER_B_PIN 32
#define ROTARY_ENCODER_BUTTON_PIN 34
#define ROTARY_ENCODER_VCC_PIN -1 
/* 27 put -1 of Rotary encoder Vcc is connected directly to 3,3V; 
else you can use declared output pin for powering rotary encoder */

//depending on your encoder - try 1,2 or 4 to get expected behaviour
//#define ROTARY_ENCODER_STEPS 1
//#define ROTARY_ENCODER_STEPS 2
#define ROTARY_ENCODER_STEPS 4

//structure for station list
typedef struct {
  char * url;  //stream url
  char * name; //stations name
} Station;

#define STATIONS 33 //number of stations in the list

//station list can easily be modified to support other stations
Station stationlist[STATIONS] PROGMEM = {
{"http://icecast.ndr.de/ndr/ndr2/niedersachsen/mp3/128/stream.mp3",         "NDR2      Nieder-    sachsen"},
{"http://icecast.ndr.de/ndr/ndr1niedersachsen/hannover/mp3/128/stream.mp3", "NDR1      Hannover"},
{"http://wdr-1live-live.icecast.wdr.de/wdr/1live/live/mp3/128/stream.mp3",  "WDR1"},
{"http://wdr-cosmo-live.icecast.wdr.de/wdr/cosmo/live/mp3/128/stream.mp3",  "WDR       COSMO"},
{"http://radiohagen.cast.addradio.de/radiohagen/simulcast/high/stream.mp3", "Radio     Hagen"},
{"http://st01.sslstream.dlf.de/dlf/01/128/mp3/stream.mp3",                  "Deutsch-  landfunk"},
{"http://dispatcher.rndfnk.com/br/br1/nbopf/mp3/low",                       "Bayern 1"},
{"http://dispatcher.rndfnk.com/br/br3/live/mp3/low",                        "Bayern 3"},
{"http://dispatcher.rndfnk.com/hr/hr3/live/mp3/48/stream.mp3",              "Hessen 3"},
{"http://stream.antenne.de/antenne",                                        "Antenne   Bayern"},
{"http://stream.1a-webradio.de/saw-deutsch/",                               "Radio 1A  Deutsche  Hits"},
{"http://stream.1a-webradio.de/saw-rock/",                                  "Radio 1A  Rock"},
{"http://streams.80s80s.de/ndw/mp3-192/streams.80s80s.de/",                 "Neue      Deutsche  Welle"},
{"http://dispatcher.rndfnk.com/br/brklassik/live/mp3/low",                  "Bayern    Klassik"},
{"http://mdr-284280-1.cast.mdr.de/mdr/284280/1/mp3/low/stream.mp3",         "MDR"},
{"http://icecast.ndr.de/ndr/njoy/live/mp3/128/stream.mp3",                  "N-JOY"},
{"http://dispatcher.rndfnk.com/rbb/rbb888/live/mp3/mid",                    "RBB"},
{"http://dispatcher.rndfnk.com/rbb/antennebrandenburg/live/mp3/mid",        "Antenne   Branden-  burg"},
{"http://wdr-wdr3-live.icecastssl.wdr.de/wdr/wdr3/live/mp3/128/stream.mp3", "WDR 3"},
{"http://wdr-wdr2-aachenundregion.icecastssl.wdr.de/wdr/wdr2/aachenundregion/mp3/128/stream.mp3","WDR 2"},
{"http://rnrw.cast.addradio.de/rnrw-0182/deinschlager/low/stream.mp3",      "NRW       Schlager"},
{"http://rnrw.cast.addradio.de/rnrw-0182/deinrock/low/stream.mp3",          "NRW       Rock-     radio"},
{"http://rnrw.cast.addradio.de/rnrw-0182/dein90er/low/stream.mp3",          "NRW       90er"},
{"http://mp3.hitradiort1.c.nmdn.net/rt1rockwl/livestream.mp3",              "RT1       Rock"},
{"http://liveradio.swr.de/sw282p3/swr1rp/play.mp3",                         "SWR1"},
{"http://liveradio.swr.de/sw282p3/swr3/play.mp3",                           "SWR3"},
{"http://liveradio.sr.de/sr/sr1/mp3/128/stream.mp3",                        "SR1"},
{"http://liveradio.sr.de/sr/sr1c2/mp3/128/stream.mp3",                      "SR1       Lounge"},
{"http://liveradio.sr.de/sr/sr3/mp3/128/stream.mp3",                        "SR3       Saarland- welle"},
{"http://liveradio.sr.de/sr/sr3c1/mp3/128/stream.mp3",                      "SR3       Schlager"},
{"http://liveradio.sr.de/sr/sr3c2/mp3/128/stream.mp3",                      "SR3       Oldiewelt"},
{"http://stream.laut.fm/cadillacradio",                                     "Cadillac  Radio"},
{"http://stream.rockantenne.de/rockandroll/stream/mp3",                     "Rock-     antenne   Rockn Roll"}};
//{"https://radio.zentonic.org/stream.mp3","zentonic"}};

//buffer size for stream buffering
const int preallocateBufferSize = 80*1024;
const int preallocateCodecSize = 29192;         // MP3 codec max mem needed
//pointer to preallocated memory
void *preallocateBuffer = NULL;
void *preallocateCodec = NULL;

//instance of prefernces
Preferences pref;

//instance for rotary encoder
AiEsp32RotaryEncoder rotaryEncoder = AiEsp32RotaryEncoder(ROTARY_ENCODER_A_PIN, ROTARY_ENCODER_B_PIN, ROTARY_ENCODER_BUTTON_PIN, ROTARY_ENCODER_VCC_PIN, ROTARY_ENCODER_STEPS);

//instance for OLECD display
Adafruit_SSD1306 display(128, 64, &Wire, -1);

//instances for audio components
AudioGenerator *decoder = NULL;
AudioFileSourceICYStream *file = NULL;
AudioFileSourceBuffer *buff = NULL;
AudioOutputI2S *out;

//Special character to show a speaker icon for current station
//uint8_t speaker[8]  = {0x3,0x5,0x19,0x11,0x19,0x5,0x3};
//global variables
uint8_t curStation = 0;   //index for current selected station in stationlist
uint8_t actStation = 0;   //index for current station in station list used for streaming 
uint32_t lastchange = 0;  //time of last selection change

//callback function will be called if meta data were found in input stream
void MDCallback(void *cbData, const char *type, bool isUnicode, const char *string)
{
  const char *ptr = reinterpret_cast<const char *>(cbData);
  (void) isUnicode; // Punt this ball for now
  // Note that the type and string may be in PROGMEM, so copy them to RAM for printf
  char s1[32], s2[64];
  strncpy_P(s1, type, sizeof(s1));
  s1[sizeof(s1)-1]=0;
  strncpy_P(s2, string, sizeof(s2));
  s2[sizeof(s2)-1]=0;
  Serial.printf("METADATA(%s) '%s' = '%s'\n", ptr, s1, s2);
  Serial.flush();
}

//stop playing the input stream release memory, delete instances
void stopPlaying() {
  if (decoder)  {
    decoder->stop();
    delete decoder;
    decoder = NULL;
  }
  if (buff)  {
    buff->close();
    delete buff;
    buff = NULL;
  }
  if (file)  {
    file->close();
    delete file;
    file = NULL;
  }
}

//start playing a stream from current active station
void startUrl() {
  stopPlaying();  //first close existing streams
  //open input file for selected url
  Serial.printf("Active station %s\n",stationlist[actStation].url);
  file = new AudioFileSourceICYStream(stationlist[actStation].url);
  //register callback for meta data
  file->RegisterMetadataCB(MDCallback, NULL); 
  //create a new buffer which uses the preallocated memory
  buff = new AudioFileSourceBuffer(file, preallocateBuffer, preallocateBufferSize);
  Serial.printf_P(PSTR("sourcebuffer created - Free mem=%d\n"), ESP.getFreeHeap());
  //create and start a new decoder
  decoder = (AudioGenerator*) new AudioGeneratorMP3(preallocateCodec, preallocateCodecSize);
  Serial.printf_P(PSTR("created decoder\n"));
  Serial.printf_P("Decoder start...\n");
  decoder->begin(buff, out);
}

//show name of current station on OLECD display
//show the "+ " in first line, current station = active station

void showStationOLED(){  
  char mystring[] = "+ ";
   display.clearDisplay();
   display.setTextSize(2); 
   display.setTextColor(SSD1306_WHITE);        // Draw white text
  if (curStation == actStation) {
    display.setCursor(0,0);
    display.println(mystring); 
  }
  
  display.setCursor(0,17);
  String name = String(stationlist[curStation].name);
  display.println(name);
  display.display();
}




//handle events from rotary encoder
void rotary_loop()
{
  //dont do anything unless value changed
  if (rotaryEncoder.encoderChanged())
  {
    uint16_t v = rotaryEncoder.readEncoder();
    Serial.printf("Station: %i\n",v);
    //set new currtent station and show its name
    if (v < STATIONS) {
      curStation = v;
     showStationOLED();
      lastchange = millis();
    }
  }
  //if no change happened within 10s set active station as current station
  if ((lastchange > 0) && ((millis()-lastchange) > 10000)){
    curStation = actStation;
    lastchange = 0;
    showStationOLED();
  }
  //react on rotary encoder switch
  if (rotaryEncoder.isEncoderButtonClicked())
  {
    //set current station as active station and start streaming
    actStation = curStation;
    Serial.printf("Active station %s\n",stationlist[actStation].name);
    pref.putUShort("station",curStation);
    startUrl();
    //call show station to display the speaker symbol
    showStationOLED();
  }
}

//interrupt handling for rotary encoder
void IRAM_ATTR readEncoderISR()
{
  rotaryEncoder.readEncoder_ISR();
}

//setup
void setup() {
  Serial.begin(115200);
  delay(1000);

   // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
  if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) { // Address 0x3D for 128x64 
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
  } 

  
  //reserve buffer für for decoder and stream
  preallocateBuffer = malloc(preallocateBufferSize);          // Stream-file-buffer
  preallocateCodec = malloc(preallocateCodecSize);            // Decoder- buffer
  if (!preallocateBuffer || !preallocateCodec)
  {
    Serial.printf_P(PSTR("FATAL ERROR:  Unable to preallocate %d bytes for app\n"), preallocateBufferSize+preallocateCodecSize);
    while(1){
      yield(); // Infinite halt
    }
  } 
  //start rotary encoder instance
  rotaryEncoder.begin();
  rotaryEncoder.setup(readEncoderISR);
  rotaryEncoder.setBoundaries(0, STATIONS, true); //minValue, maxValue, circleValues true|false (when max go to min and vice versa)
  rotaryEncoder.disableAcceleration();

  //create I2S output for the display 
  //the second parameter 1 means use the internal DAC
  out = new AudioOutputI2S(0,1);
 // lcd.init();
 // lcd.backlight();
 // lcd.clear();
 // lcd.home();

  
  //init WiFi HHexenmeister.2 (my smartphone) first
  //Serial.println("");
  Serial.println("Connecting to Smartphone");
  WiFi.disconnect();
  WiFi.softAPdisconnect(true);
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID1, PSK1);
  delay(5000); // 5 sec to connect
  
  display.clearDisplay();
  display.setTextSize(1); 
  display.setTextColor(SSD1306_WHITE);        // Draw white text
  display.setCursor(0,0);
     display.println(F("Hexenmeister.2")); 
  if (WiFi.status() == WL_CONNECTED){
    
    display.setCursor(0,17);
    display.println(WiFi.localIP());
   
    }
    else {
    display.setCursor(0,17);
    display.println(F("failed"));
      }
       display.display();
  
    
  if (WiFi.status() == WL_CONNECTED) { 
    Serial.print(SSID1); Serial.print(" "); Serial.println(WiFi.localIP());
    }
  
  // init WiFi cloud7 second if lugsaar failed
  if (WiFi.status() != WL_CONNECTED) {
  //Serial.println("");
  Serial.println("Connecting to Hexenmeister.2 WiFi failed, try cloud7 WiFi");
//  lcd.clear();
//  lcd.home();
//  lcd.print("lugsaar failed");
  //Serial.println(" Connecting to cloud7 WiFi");
  WiFi.disconnect();
  WiFi.softAPdisconnect(true);
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID2, PSK2);
  //Serial.println("Connected to cloud7");
  delay(5000); // 5 sec to connect

  display.clearDisplay();
  display.setTextSize(1); 
  display.setTextColor(SSD1306_WHITE);        // Draw white text
  display.setCursor(0,0);
     display.println(F("cloud7")); 
  if (WiFi.status() == WL_CONNECTED){
    
    display.setCursor(0,17);
    display.println(WiFi.localIP());

    }
    else {
    display.setCursor(0,17);
    display.println(F("failed"));
      }
       display.display();
  
  Serial.print(SSID2); Serial.print(" "); Serial.println(WiFi.localIP());

//  lcd.clear();
//  lcd.home();
//  lcd.print(SSID2);
//  lcd.setCursor(0,1);
//  lcd.print(WiFi.localIP());
  delay(3000);
  }
  
  //create I2S output do use with decoder
  //the second parameter 1 means use the internal DAC
  //out = new AudioOutputI2S(0,1);
  //init the LCD display
  //lcd.init();
  //lcd.backlight();
  //lcd.createChar(1, speaker);
  //set current station to 0
  curStation = 0;
  //start preferences instance
  pref.begin("radio", false);
  //set current station to saved value if available
  if (pref.isKey("station")) curStation = pref.getUShort("station");
  Serial.printf("Gespeicherte Station %i von %i\n",curStation,STATIONS);
  if (curStation >= STATIONS) curStation = 0;
  //set active station to current station 
  //show on display and start streaming
  //curStation = 15;
  actStation = curStation;
  showStationOLED();
  startUrl();

 //showStationOLED();
}

void loop() {
  //showStationOLED();
  //delay(5000);
  //check if stream has ended normally not on ICY streams
  if (decoder->isRunning()) {
    if (!decoder->loop()) {
      decoder->stop();
    }
  } else {
    Serial.printf("MP3 done\n");

    // Restart ESP when streaming is done or errored
    delay(10000);

    ESP.restart();
  }
  //read events from rotary encoder
  rotary_loop();

}
