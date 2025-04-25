package kr.kh.riot.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.kh.riot.model.vo.BoardVO;
import kr.kh.riot.model.vo.FileVO;
import kr.kh.riot.model.vo.PositionVO;
import kr.kh.riot.model.vo.PostVO;
import kr.kh.riot.model.vo.UserVO;
import kr.kh.riot.pagination.DuoCriteria;
import kr.kh.riot.pagination.PageMaker;
import kr.kh.riot.pagination.PostCriteria;
import kr.kh.riot.service.PostService;

@Controller
@RequestMapping("/post")
public class PostController {

	@Autowired
	private PostService postService;
	
	@GetMapping("/list")
	public String list(@RequestParam(value = "num", defaultValue = "0") int num, Model model) {
		
		
		List<BoardVO> boardList = postService.getBoardList();
		model.addAttribute("boardList", boardList);
		model.addAttribute("num", num);
		
		
		return "/post/list";		
	}
	

	@PostMapping("/list")
	public Object PostList(Model model, @RequestBody PostCriteria cri) {			
		//cri.setPerPageNum(2);
		List<PostVO> postList = postService.getPostList(cri);
		System.out.println(postList);
		PageMaker pm = postService.getPageMaker(cri);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String today = sdf.format(new Date());
		
		for(PostVO post : postList) {
			post.setSummary(htmlToText(post.getPo_content(), 20));			//요약
		}
		
		model.addAttribute("postList", postList);
		model.addAttribute("pm",pm);
		model.addAttribute("today", today);
		
		return"post/sub";					
	}
	
	
	@GetMapping("/insert")
	public String insert(Model model, Integer bo_key) {
		bo_key = bo_key == null ? 0 : bo_key;
		
		List<BoardVO> boardList = postService.getBoardList();
		
		model.addAttribute("boardList", boardList);
		model.addAttribute("bo_key", bo_key);
		return "/post/insert";
	}
	@PostMapping("/insert")
	public String insertPost(Model model, PostVO post, HttpSession session, MultipartFile[] fileList) {
		
		UserVO user = (UserVO)session.getAttribute("user");
		if(postService.insertPost(post, user, fileList)) {
			model.addAttribute("url", "/post/list");
			model.addAttribute("msg", "게시글을 등록했습니다.");
		}else {
			model.addAttribute("url", "/post/list");
			model.addAttribute("msg", "게시글을 등록하지 못했습니다.");
		}
		
		return "message";
	}
	
	@GetMapping("/detail/{po_key}")
	public String detail(Model model,@PathVariable("po_key") int po_key, HttpServletRequest request) {

		//게시글을 가져와서 화면에 전달
		PostVO post = postService.getPost(po_key);
		
		//첨부파일을 가져옴
		List<FileVO> list = postService.getFileList(po_key);	
		String contextPath = request.getContextPath();
		for (int i = 0; i < list.size(); i++) {
		    String tag = "{이미지:" + (i + 1) + "}";
		    String imgTag = "<img src='" + contextPath + "/download" + list.get(i).getFi_name() + "' style='max-width:100%; height:auto;' />";
	        post.setPo_content(post.getPo_content().replace(tag, imgTag));		    post.setPo_content(post.getPo_content().replace(tag, imgTag));
		}
		
		model.addAttribute("post", post);
		model.addAttribute("fileList", list);
		return "/post/detail";
	}
	
	@GetMapping("/delete/{po_key}")
	public String delete(Model model, @PathVariable("po_key")int po_key, HttpSession session) {
		
		UserVO user = (UserVO)session.getAttribute("user");
		if(postService.deletePost(po_key, user)) {
			model.addAttribute("url", "/post/list");
			model.addAttribute("msg", "게시글을 삭제했습니다.");
		}else {
			model.addAttribute("url", "/post/detail/"+po_key);
			model.addAttribute("msg", "게시글을 삭제하지 못했습니다.");
		}
		
		return "message";
	}
	@GetMapping("/update/{po_key}")
	public String update(Model model, @PathVariable("po_key")int po_key, HttpSession session) {
		
		UserVO user = (UserVO)session.getAttribute("user");
		PostVO post = postService.getPost(po_key);

		if(post == null || user == null || post.getPo_us_key() != (user.getUs_key())) {
			model.addAttribute("url", "/post/detail/"+po_key);
			model.addAttribute("msg", "작성자가 아니거나 없는 게시글입니다.");
			return "message";
		}
		List<FileVO> list = postService.getFileList(po_key);
		
		List<BoardVO> boardList = postService.getBoardList();
		
		model.addAttribute("boardList", boardList);
		model.addAttribute("post", post);
		model.addAttribute("fileList", list);
		return "/post/update";
	}
	
	@PostMapping("/update")
	public String updatePost(Model model, PostVO post, HttpSession session, 
			MultipartFile[] fileList, int [] delNums) {
		
		UserVO user = (UserVO)session.getAttribute("user");
		if(postService.updatePost(post, user, fileList, delNums)) {
			model.addAttribute("msg", "게시글을 수정했습니다.");
		}else {
			model.addAttribute("msg", "게시글을 수정하지 못했습니다.");
		}
		
		model.addAttribute("url", "/post/detail/" + post.getPo_key());
		return "message";
	}
	
	
	
	/*
	@ResponseBody
	@PostMapping("/like")
	public int like(Model model, @RequestBody LikeVO like, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		
		return postService.updateLike(like, user);
	}*/

	@GetMapping("/duo")
	public String duo(Model model, PostCriteria cri, Integer num) {
		/*
		cri.setPerPageNum(2);
		List<PostVO> list = postService.getPostList(cri);
		
		List<BoardVO> boardList = postService.getBoardList();
		
		PageMaker pm = postService.getPageMaker(cri);
		
		int lastBoardNum = boardList.get(boardList.size()-1).getBo_key();
				
		num = num == null ? 0 : num;
		if(num<0 || lastBoardNum < num) num = 0;
		
		model.addAttribute("postList", list);
		model.addAttribute("boardList", boardList);
		model.addAttribute("pm", pm);
		model.addAttribute("boardNum", num);
		*/
		
		return "/post/duo";
	}

    @GetMapping("/duo/list")
    public String duoList(Model model, DuoCriteria cri, Integer num) {
        List<PositionVO> duoList = postService.getDuoList();
        int total = duoList.size();
        
        PageMaker pm = postService.getPageMaker(cri);

        //List<DuoBoardDTO> boardList = postService.getDuoList(pageDTO.getStartRow(), perPage);
        
        num = num == null ? 0 : num;
		if(num<0 || total < num) num = 0;
        
        model.addAttribute("list", duoList);
        model.addAttribute("page", pm);
        model.addAttribute("boardNum", num);
        
        return "/post/duoList";
    }
	
	
	
	@GetMapping("/duo/lines")
	@ResponseBody
	public List<PositionVO> getLines(@RequestParam("pbKey") int pbKey) {
	    return postService.getPositions(pbKey);
	}

	
	public static String htmlToText(String html, int maxLength) {
	    // HTML 태그 제거
	    String plainText = html.replaceAll("<[^>]*>", "").replace("&nbsp;", " ").trim();

	    // 길이 제한
	    if (plainText.length() > maxLength) {
	        return plainText.substring(0, maxLength) + "...";
	    }
	    return plainText;
	}
	

}
