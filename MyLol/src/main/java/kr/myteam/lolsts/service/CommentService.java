package kr.myteam.lolsts.service;

import java.util.List;

import kr.myteam.lolsts.model.vo.CommentVO;
import kr.myteam.lolsts.model.vo.UserVO;
import kr.myteam.lolsts.pagination.Criteria;
import kr.myteam.lolsts.pagination.PageMaker;

public interface CommentService {

	boolean insertComment(CommentVO comment, UserVO user);

	List<CommentVO> getCommentList(Criteria cri);

	PageMaker getPageMaker(Criteria cri);

	boolean deleteComment(int co_key, UserVO user);

	boolean updateComment(CommentVO comment, UserVO user);

}
