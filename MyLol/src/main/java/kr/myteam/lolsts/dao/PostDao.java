package kr.myteam.lolsts.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.myteam.lolsts.model.vo.BoardVO;

public interface PostDao {

	List<BoardVO> selectBoardList();

	boolean insertBoard(@Param("bo_name")String name);

	boolean updateBoard(@Param("board")BoardVO board);

	boolean deleteBoard(@Param("bo_key")int num);


	

}
