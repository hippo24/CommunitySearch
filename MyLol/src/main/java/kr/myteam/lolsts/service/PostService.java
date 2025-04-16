package kr.myteam.lolsts.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.myteam.lolsts.model.vo.BoardVO;
import kr.myteam.lolsts.model.vo.FileVO;
import kr.myteam.lolsts.model.vo.PostVO;
import kr.myteam.lolsts.model.vo.UserVO;
import kr.myteam.lolsts.pagination.PageMaker;
import kr.myteam.lolsts.pagination.PostCriteria;

public interface PostService {

	List<BoardVO> getBoardList();

	boolean insertBoard(String name);

	boolean updateBoard(BoardVO board);

	boolean deleteBoard(int num);

	List<PostVO> getPostList(PostCriteria cri);

	PageMaker getPageMaker(PostCriteria cri);

	boolean insertPost(PostVO post, UserVO user, MultipartFile[] fileList);

	PostVO getPost(int po_key);

	boolean deletePost(int po_key, UserVO user);

	List<FileVO> getFileList(int po_key);

	boolean updatePost(PostVO post, UserVO user, MultipartFile[] fileList, int[] delNums);



	

}
