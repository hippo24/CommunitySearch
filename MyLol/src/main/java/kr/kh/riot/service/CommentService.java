package kr.kh.riot.service;

import java.util.List;

import kr.kh.riot.model.vo.CommentVO;
import kr.kh.riot.model.vo.UserVO;
import kr.kh.riot.pagination.Criteria;
import kr.kh.riot.pagination.PageMaker;

public interface CommentService {

	boolean insertComment(CommentVO comment, UserVO user);

	List<CommentVO> getCommentList(Criteria cri);

	PageMaker getPageMaker(Criteria cri);

	boolean deleteComment(int co_key, UserVO user);

	boolean updateComment(CommentVO comment, UserVO user);

}
