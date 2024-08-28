//+------------------------------------------------------------------+
//|                                              priceActionTend.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+


 double  prevHigh , prevLow;
 
 
 
 int    totalBias       = 0;
 
 bool   addedTotalBias  = false;
  

 
 int trendVal[10];

int OnInit()
  {
  
   int localBias = getBias();
    
    if(localBias == -999) {
    
    Print("There was an error getting the total Bias");
    
    } else {
    
     Print("The total bias is: "+IntegerToString(localBias));
     
    }
  
 

   return(INIT_SUCCEEDED);
  }
  
  
  
void OnDeinit(const int reason)
  {
 
   
  }



void OnTick()
  {


   
  }
//+------------------------------------------------------------------+


int getBias(){
// Looping through the the candles
 for(int i =0; i<=9; i++)
    {
      if(i == 0)
          {
            trendVal[i] = 0;
             continue;
          }
    
    
      // Get the high and low prices for the previous candle
      prevHigh = iHigh(_Symbol,PERIOD_CURRENT,i+1);
      prevLow  = iLow(_Symbol,PERIOD_CURRENT,i+1);  
      
      prevHigh = NormalizeDouble(prevHigh,_Digits);
      prevLow  = NormalizeDouble(prevLow,_Digits);
      
             
       // Get the high and low prices for the current period
      double currentHigh = iHigh(_Symbol,PERIOD_CURRENT,i); 
      double currentLow  =  iLow(_Symbol,PERIOD_CURRENT,i); 
      
      currentHigh = NormalizeDouble(currentHigh,_Digits);
      currentLow  = NormalizeDouble(currentLow,_Digits);
      
      
      
      // Determine the trend for the current period
      
      if(currentHigh > prevHigh && currentLow > prevLow)
        {
         trendVal[i] = 1;
         
        }
        
        else if (currentHigh < prevHigh && currentLow < prevLow)
        {
         trendVal[i] = -1; 
        }
        
        else{
        trendVal[i] = 0;
        } 
          
        Print("================================++======================================");
        
        Print("Current High is: "+DoubleToString(currentHigh) +" The previous High is: "+ DoubleToString(prevHigh) );
        Print("Current Low is: "+ DoubleToString(currentLow)  +" The previous Low is: "+DoubleToString(prevLow) );
        Print("The index value: "+ trendVal[i]);

    }
  

  // Calculate the total bias by summing the trend values
  for(int i =0; i<ArraySize(trendVal); i++){
  
  
   totalBias +=trendVal[i];
   
   // Check if this is the last element in the array
      if(i == ArraySize(trendVal)-1)
          {
             addedTotalBias = true;
          }
  }
  
  
  // Output the total bias
  Print("Total Bias is: "+ IntegerToString(totalBias));
  
  // Return the total bias if it was successfully calculated
  
    if(addedTotalBias){
       return totalBias;
    }
    
    // Fallback return value for error
    
    return -999;
  
}