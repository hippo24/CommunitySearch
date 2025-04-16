package kr.myteam.lolsts.service;

import java.util.List;

import javax.annotation.Resource;

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
import kr.myteam.lolsts.utils.UploadFileUtils;

@Service
public class PostServiceImp implements PostService{

	@Autowired
	private PostDao postDao;

	@Resource
	private String uploadPath;
	
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
		return postDao.selectPostList(cri);
	}

	@Override
	public PageMaker getPageMaker(PostCriteria cri) {
		int totalCount = postDao.selectCountPostList(cri);
		return new PageMaker(10, cri, totalCount);
	}

	@Override
	public boolean insertPost(PostVO post, UserVO user, MultipartFile[] fileList) {
		if(	post == null || 
				post.getPo_title().trim().length() == 0 || 
				post.getPo_content().length() == 0) {
				return false;
			}
			if(user == null) {
				return false;
			}
			post.setPo_us_key(user.getUs_key());
			boolean res = postDao.insertPost(post);
			
			if(!res) {
				return false;
			}
			
			if(fileList == null || fileList.length == 0) {
				return true;
			}
			
			for(MultipartFile file : fileList) {
				uploadFile(file, post.getPo_key());
			}
			return true;
		}

	@Override
	public PostVO getPost(int po_key) {
		return postDao.selectPost(po_key);
	}

	@Override
	public boolean deletePost(int po_key, UserVO user) {
		if(user == null) {
			return false;
		}
		//게시글 정보를 가져옴
		PostVO post = postDao.selectPost(po_key);
		//게시글의 작성자와 회원이 다르면 false 리턴
		if(post == null || post.getPo_us_key() != user.getUs_key()) {
			return false;
		}
		//게시글 수정
		boolean res = postDao.deletePost(po_key);
		
		if(!res) {
			return false;
		}
		//첨부파일 삭제
		List<FileVO> fileList = postDao.selectFileList(po_key);
		
		if(fileList == null || fileList.size() == 0) {
			return true;
		}
		
		for(FileVO fileVo : fileList) {
			deleteFile(fileVo);
		}
		//db에서 해당 첨부파일을 삭제
		return true;
	}

	@Override
	public List<FileVO> getFileList(int po_key) {
		return postDao.selectFileList(po_key);
	}

	@Override
	public boolean updatePost(PostVO post, UserVO user, MultipartFile[] fileList, int[] delNums) {
		if(	post == null || 
				post.getPo_title().trim().length() == 0 || 
				post.getPo_content().length() == 0) {
				return false;
			}
			if(user == null) {
				return false;
			}

			PostVO dbPost = postDao.selectPost(post.getPo_key());


			if(dbPost == null || dbPost.getPo_us_key()!= user.getUs_key()) {
				return false;
			}
			boolean res = postDao.updatePost(post);
			
			if(!res) {
				return false;
			}
			
			if(fileList == null || fileList.length == 0) {
				return true;
			}
			//새 첨부파일 추가
			for(MultipartFile file : fileList) {
				uploadFile(file, post.getPo_key());
			}
			
			if(delNums == null || delNums.length == 0) {
				return true;
			}
			//x버튼 눌러서 제거한 첨부파일 제거
			for(int fi_num : delNums) {
				FileVO fileVo = postDao.selectFile(fi_num);
				deleteFile(fileVo);
			}
			
			return true;
		}

	private void uploadFile(MultipartFile file, int po_num) {
		String fi_ori_name = file.getOriginalFilename();
		//파일명이 없으면
		if(fi_ori_name == null || fi_ori_name.length() == 0) {
			return;
		}
		try {
			String fi_name = UploadFileUtils.uploadFile(uploadPath, fi_ori_name, file.getBytes());
			FileVO fileVo = new FileVO(fi_ori_name, fi_name, po_num);
			postDao.insertFile(fileVo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void deleteFile(FileVO fileVo) {
		if(fileVo == null) {
			return;
		}
		//실제 첨부파일을 삭제
		UploadFileUtils.deleteFile(uploadPath, fileVo.getFi_name());
		
		//db에서 해당 첨부파일을 삭제
		postDao.deleteFile(fileVo.getFi_num());
	}
}
