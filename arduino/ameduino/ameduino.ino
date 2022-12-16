// Ta wersja jest ok

//byte buf1, buf2;
//byte res;

void setup() {
  ADMUX =  B01100111;           // set internal aref and port A7
  ADCSRA = B10101100;           // ADC enable, interrupt enable, 16 prescaler
  ADCSRB = B00000000;           // free running mode
  sei();            // enable interrupts
  ADCSRA |=B01000000;           // start first conversion
  Serial.begin(1000000);
}

void loop() {

}

ISR(ADC_vect) {
    //buf1 = ADCL;
    //buf2 = ADCH;
//    //Serial.write(ADCH);
//
//    res = ADCL >> 2 | ADCH << 6;
    //Serial.write(ADCL >> 2 | ADCH << 6);
    //Serial.write(buf1);
    Serial.write(ADCH);
 
}
