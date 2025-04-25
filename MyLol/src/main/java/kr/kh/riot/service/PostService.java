package kr.kh.riot.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.kh.riot.model.vo.BoardVO;
import kr.kh.riot.model.vo.FileVO;
import kr.kh.riot.model.vo.PositionVO;
import kr.kh.riot.model.vo.PostVO;
import kr.kh.riot.model.vo.UserVO;
import kr.kh.riot.pagination.Criteria;
import kr.kh.riot.pagination.PageMaker;

public interface PostService {

	List<BoardVO> getBoardList();

	boolean insertBoard(String name);

	boolean updateBoard(BoardVO board);

	boolean deleteBoard(int num);

	List<PostVO> getPostList(Criteria cri);

	PageMaker getPageMaker(Criteria cri);

	boolean insertPost(PostVO post, UserVO user, MultipartFile[] fileList);

	PostVO getPost(int po_key);

	boolean deletePost(int po_key, UserVO user);

	List<FileVO> getFileList(int po_key);

	boolean updatePost(PostVO post, UserVO user, MultipartFile[] fileList, int[] delNums);

	List<PositionVO> getPositions(int pbKey);

	List<PositionVO> getDuoList();



	

}
