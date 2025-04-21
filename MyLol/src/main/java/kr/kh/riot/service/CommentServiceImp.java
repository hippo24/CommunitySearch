package kr.kh.riot.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.kh.riot.dao.CommentDAO;
import kr.kh.riot.model.vo.CommentVO;
import kr.kh.riot.model.vo.UserVO;
import kr.kh.riot.pagination.Criteria;
import kr.kh.riot.pagination.PageMaker;

@Service
public class CommentServiceImp implements CommentService {

	@Autowired
	CommentDAO commentDao;

	@Override
	public boolean insertComment(CommentVO comment, UserVO user) {
		if (comment == null) {
			return false;
		}
		if (user == null) {
			return false;
		}
		try {
			comment.setCo_us_key(user.getUs_key());
			return commentDao.insertComment(comment);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public List<CommentVO> getCommentList(Criteria cri) {
		if (cri == null) {
			return null;
		}
		return commentDao.selectCommentList(cri);
	}

	@Override
	public PageMaker getPageMaker(Criteria cri) {
		if (cri == null) {
			return null;
		}
		int totalCount = commentDao.selectCountCommentList(cri);
		return new PageMaker(3, cri, totalCount);
	}

	@Override
	public boolean deleteComment(int co_key, UserVO user) {
		if (user == null) {
			return false;
		}
		// 작성자 확인
		CommentVO comment = commentDao.selectComment(co_key);

		if (comment == null || comment.getCo_us_key() != user.getUs_key()) {
			return false;
		}
		return commentDao.deleteComment(co_key);
	}

	@Override
	public boolean updateComment(CommentVO comment, UserVO user) {
		if (comment == null || user == null) {
			return false;
		}

		CommentVO dbComment = commentDao.selectComment(comment.getCo_key());

		if (dbComment == null || dbComment.getCo_key() != user.getUs_key()) {
			return false;
		}
		return commentDao.updateComment(comment);
	}
}
