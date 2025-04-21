package kr.kh.riot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.kh.riot.model.vo.CommentVO;
import kr.kh.riot.pagination.Criteria;

public interface CommentDAO {

	boolean insertComment(@Param("comment")CommentVO comment);

	List<CommentVO> selectCommentList(@Param("cri")Criteria cri);

	CommentVO selectComment(@Param("co_key")int co_key);

	boolean deleteComment(@Param("co_key")int co_key);

	int selectCountCommentList(@Param("cri")Criteria cri);

	boolean updateComment(@Param("comment")CommentVO comment);
	
}
