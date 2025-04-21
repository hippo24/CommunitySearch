package kr.kh.riot.pagination;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PostCriteria extends Criteria {

	private int po_bo_key;
	String orderBy;

	public PostCriteria(int page, int perPageNum) {
		super(page, perPageNum);
	}
	
	
}
