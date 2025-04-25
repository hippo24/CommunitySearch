package kr.kh.riot.model.vo;

import java.util.Date;

import lombok.Data;

@Data
public class PositionVO {

	int PB_KEY, PB_US_KEY, PB_STATE; 
	String PB_CONTENT; 
	Date PB_TIME, PB_UPD;  
	////////////////////////////////
	int PS_ORDER; 
	String PS_LINE; 
	
	
	
	
}
