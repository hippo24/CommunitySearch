package kr.kh.riot.model.vo;

import java.util.Date;

import lombok.Data;

@Data
public class CommentVO {

	int co_key, co_po_key, co_us_key, co_ori_key;
	String co_content;
	Date co_time, co_upd;
	int co_ano;
	
	
}
