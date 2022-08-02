#include <tiny13a.h>
#include <delay.h> 
#include <1wire.h> 

#define SBR(port, bit)        port |= (1<<bit)
#define CBR(port, bit)        port &= (~(1<<bit))
#define INV(port, bit)        port ^= (1<<bit)
#define SBRC(port, bit)      ((port & (1<<bit)) == 0)
#define SBRS(port, bit)      ((port & (1<<bit)) != 0)

#define BTN             2
#define BUZZER          0     
#define POWER           OCR0B  
#define BTN_PRESSED     !PINB.2

//Settings
#define TEMP_SW         4
#define STEP_TIME       3
#define STEP_POWER      20
#define MAX_TIME        15
#define MAX_POWER       100
#define DEFAULT_POWER   40
#define DEFAULT_TIME    12

eeprom unsigned char power_set;
eeprom unsigned char time_set;

//**********************
unsigned char flag;      
#define SETTINGS        0

char btn_func(void);

void initdev(){
//Config port
    SBR(PORTB, BTN);
    CBR(DDRB, BTN);
    SBR(DDRB, BUZZER);
    SBR(DDRB, 1);
// Timer/Counter 0 initialization
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (1<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (1<<WGM00);  //TOP on OCR0A Freq PWM = 90kHz 
TCCR0B=(1<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00); //freq DIV 1
TCNT0=0x00;
OCR0A=100;  //TOP 
OCR0B=MAX_POWER;   //PWM, OCR0B pin only! (whith TOP on OCR0A)
 
//Turnoff analogcomp
    ACSR=(1<<ACD);        
}

void buzz(unsigned char cnt, unsigned int del ){
   unsigned char i;
    
    for(i=0; i<cnt; i++){
        SBR(PORTB, BUZZER); 
        delay_ms(del); 
        CBR(PORTB, BUZZER);
        delay_ms(del); 
    }       
}

void delay_min(unsigned char var){
    unsigned char min, i;
    
    for(min=0; min<var; min++){
        for(i=0; i<60; i++){
            delay_ms(1000); 
            btn_func();              
        }        
    }                  
}

void rd_sets(unsigned char var){
    
    //CLEAR EEPROM BYTE = 255, CHECK EEPROM AND SET DEFAULT, IF CLEAR. 
    if(power_set > MAX_POWER) power_set = DEFAULT_POWER;
    if(time_set > MAX_TIME) time_set = DEFAULT_TIME; 
    
     switch(var){
        case 1:
            buzz(power_set/STEP_POWER, 200);    
        break;
        
        case 2:
            buzz(time_set/STEP_TIME, 200);
        break;
        
        default:break;
     }
}

char btn_press(){
unsigned int btn_cnt=0;

    while(BTN_PRESSED){ 
        btn_cnt++;              
        if(btn_cnt == 100){
            buzz(1, 2000);            
            return 2;
        } 
        delay_ms(50);       
    } 
    
    if(btn_cnt)
        return 1;
    else
        return 0;
}

char btn_func(){
unsigned char menu_state, btn_state;
     
    if(btn_press()==2){
        if(SBRC(flag, SETTINGS))
            SBR(flag, SETTINGS);
        else
            CBR(flag, SETTINGS);
    }  
     
    if(SBRC(flag, SETTINGS))
        return 0;
    
    menu_state=1;
    rd_sets(menu_state);
      
    while(SBRS(flag, SETTINGS)){           
        btn_state = btn_press();
        if(btn_state==1){
            switch(menu_state){
                case 1:
                    if(power_set > MAX_POWER) 
                        power_set=STEP_POWER;
                    else     
                        power_set+=STEP_POWER;                      
                break;
                    
                case 2:  
                    if(time_set > MAX_TIME) 
                        time_set=STEP_TIME;
                    else     
                        time_set+=STEP_TIME; 
                break;
                
                default:break;
            }
            rd_sets(menu_state);                     
        }
        else if(btn_state==2){
            menu_state++;
            if(menu_state > 2)  
                menu_state=0;
            rd_sets(menu_state);
        }
        
        if(!menu_state)
            CBR(flag, SETTINGS);  
    }    
    buzz(1, 50);           
}

signed char read_ds18b20(){ 
  unsigned char data[2];
  signed char temp;  
  signed int raw;
  
  w1_init();
  delay_ms(10);
  if(w1_init()){
    w1_write(0xCC);
    w1_write(0x44);
    delay_ms(1000);
    //Читаем данные с датчика
    w1_init();
    w1_write(0xCC);
    w1_write(0xBE);    
      data[0] = w1_read();
      data[1] = w1_read();  

    raw = (data[1] << 8) | (data[0] & ~0x03);
    temp = raw>>4;              
    
    return temp;
  } else return -127;
}

void main(){
    signed char t;
    initdev();          
    t= read_ds18b20();
    if(t<-30 || t>60){
        buzz(1, 5000);
        delay_ms(3000);
        goto DEFAULT;
    } 
        
            if( t<TEMP_SW ){
DEFAULT:        buzz(1, 50);
                POWER=MAX_POWER;
                delay_min(time_set);
                buzz(2, 50);    
                POWER=power_set; 
            }   
            else{
                buzz(2, 50);
                POWER=power_set;
            } 
        
    while(1){ 
        delay_ms(1000); 
        btn_func();
    }
}
