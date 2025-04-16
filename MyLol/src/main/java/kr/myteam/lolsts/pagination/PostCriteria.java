package kr.myteam.lolsts.pagination;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PostCriteria extends Criteria {

	private int po_bo_key;

	public PostCriteria(int page, int perPageNum) {
		super(page, perPageNum);
	}
	
	
}
