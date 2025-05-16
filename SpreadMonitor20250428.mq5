//+------------------------------------------------------------------+
//|                                              SpreadMonitor.mq4/5 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025 HaoWei"
#property version "1.00"
#property strict

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots 2
#property indicator_type1 DRAW_HISTOGRAM
#property indicator_color1 clrRed
#property indicator_label1 "Max"
#property indicator_type2 DRAW_HISTOGRAM
#property indicator_color2 clrLime
#property indicator_label2 "Min"






double MaxBuffer[];
double MinBuffer[];
bool LaunchBool;
double SpreadMax;
double SpreadMin;
datetime iTimeOld;
void OnInit(){
	
	SetIndexBuffer(0,MaxBuffer,INDICATOR_DATA);
	SetIndexBuffer(1,MinBuffer,INDICATOR_DATA);
	
	ArraySetAsSeries(MaxBuffer,true);
	ArraySetAsSeries(MinBuffer,true);
	
	PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,1);
	PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,1);
	
	IndicatorSetInteger(INDICATOR_DIGITS,0);
	
	IndicatorSetString(INDICATOR_SHORTNAME,"SpreadMonitor");
}


void OnDeinit(const int reason){
	
	SpreadMax=0;
	SpreadMin=0;
	
	ArrayInitialize(MaxBuffer,EMPTY_VALUE);
	ArrayInitialize(MinBuffer,EMPTY_VALUE);
}


int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[]){
	
	if(LaunchBool==false){
		LaunchBool=true;
		
		for(int ith=0;ith<rates_total;ith++){
			MaxBuffer[ith]=EMPTY_VALUE;
			MinBuffer[ith]=EMPTY_VALUE;
		}
		
		SpreadMax=(double)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
		SpreadMin=(double)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
		
		iTimeOld=iTime(Symbol(),PERIOD_CURRENT,0);
	}
	
	if(iTime(Symbol(),PERIOD_CURRENT,0)!=iTimeOld){
		iTimeOld=iTime(Symbol(),PERIOD_CURRENT,0);
		
		MaxBuffer[1]=-SpreadMax;
		MinBuffer[1]=SpreadMin;
		
		SpreadMax=(double)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
		SpreadMin=(double)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
	}
	
	if(SymbolInfoInteger(Symbol(),SYMBOL_SPREAD)>SpreadMax){
		SpreadMax=(double)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
	}else{
		if(SymbolInfoInteger(Symbol(),SYMBOL_SPREAD)<SpreadMin){
			SpreadMin=(double)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
		}
	}
	
	MaxBuffer[0]=-SpreadMax;
	MinBuffer[0]=SpreadMin;
	
	return(rates_total);
}