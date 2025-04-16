package kr.myteam.lolsts.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.myteam.lolsts.dao.PostDao;
import kr.myteam.lolsts.model.vo.BoardVO;
import kr.myteam.lolsts.model.vo.FileVO;
import kr.myteam.lolsts.model.vo.PostVO;
import kr.myteam.lolsts.model.vo.UserVO;
import kr.myteam.lolsts.pagination.PageMaker;
import kr.myteam.lolsts.pagination.PostCriteria;

@Service
public class PostServiceImp implements PostService{

	@Autowired
	private PostDao postDao;

	@Override
	public List<BoardVO> getBoardList() {

		return postDao.selectBoardList();
	}

	@Override
	public boolean insertBoard(String name) {

		try {
			return postDao.insertBoard(name);			
		} catch (Exception e) {
			return false;
		}
	}

	@Override
	public boolean updateBoard(BoardVO board) {
		if(board == null) {
			return false;
		}
		
		try {
			return postDao.updateBoard(board);
		}catch (Exception e) {
			return false;
		}
	}

	@Override
	public boolean deleteBoard(int num) {

		
		
		return postDao.deleteBoard(num);
	}

	@Override
	public List<PostVO> getPostList(PostCriteria cri) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public PageMaker getPageMaker(PostCriteria cri) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean insertPost(PostVO post, UserVO user, MultipartFile[] fileList) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public PostVO getPost(int po_key) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean deletePost(int po_key, UserVO user) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public List<FileVO> getFileList(int po_key) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean updatePost(PostVO post, UserVO user, MultipartFile[] fileList, int[] delNums) {
		// TODO Auto-generated method stub
		return false;
	}


}
