package kr.myteam.lolsts.model.vo;

import java.util.Date;

import lombok.Data;

@Data
public class PostVO {

	int po_key, po_us_key, po_bo_key;
	String po_type, po_title;
	String po_content;
	Date po_time, po_upd;
	
	
}
