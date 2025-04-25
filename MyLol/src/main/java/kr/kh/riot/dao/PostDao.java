package kr.kh.riot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.kh.riot.model.vo.BoardVO;
import kr.kh.riot.model.vo.FileVO;
import kr.kh.riot.model.vo.PositionVO;
import kr.kh.riot.model.vo.PostVO;
import kr.kh.riot.pagination.Criteria;

public interface PostDao {

	List<BoardVO> selectBoardList();

	boolean insertBoard(@Param("bo_name")String name);

	boolean updateBoard(@Param("board")BoardVO board);

	boolean deleteBoard(@Param("bo_key")int bo_key);

	boolean insertPost(@Param("post")PostVO post);

	PostVO selectPost(@Param("po_key")int po_key);

	boolean deletePost(@Param("po_key")int po_key);

	boolean updatePost(@Param("post")PostVO post);

	void insertFile(@Param("file")FileVO fileVo);

	List<FileVO> selectFileList(@Param("po_key")int po_key);

	void deleteFile(@Param("fi_key")int fi_key);

	FileVO selectFile(@Param("fi_key")int fi_key);

	int selectCountPostList(@Param("criteria")Criteria cri);

	List<PostVO> selectPostList(@Param("criteria")Criteria cri);

	List<PositionVO> selectPositions(@Param("pb_key")int pb_key);

	List<PositionVO> selectDuoList();

}
