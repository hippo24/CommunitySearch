package kr.myteam.lolsts.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.myteam.lolsts.model.vo.CommentVO;
import kr.myteam.lolsts.pagination.Criteria;

public interface CommentDAO {

	boolean insertComment(@Param("comment")CommentVO comment);

	List<CommentVO> selectCommentList(@Param("cri")Criteria cri);

	CommentVO selectComment(@Param("co_key")int co_key);

	boolean deleteComment(@Param("co_key")int co_key);

	int selectCountCommentList(@Param("cri")Criteria cri);

	boolean updateComment(@Param("comment")CommentVO comment);
	
}
