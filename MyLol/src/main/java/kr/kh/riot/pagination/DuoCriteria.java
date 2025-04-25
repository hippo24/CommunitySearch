package kr.kh.riot.pagination;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DuoCriteria extends Criteria {

	

	public DuoCriteria(int page, int perPageNum) {
		super(page, perPageNum);
	}
	
	
}
