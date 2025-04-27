package kr.kh.riot.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.kh.riot.model.vo.BoardVO;
import kr.kh.riot.model.vo.PostVO;
import kr.kh.riot.pagination.PageMaker;
import kr.kh.riot.pagination.PostCriteria;
import kr.kh.riot.service.PostService;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private PostService postService;
	
	
	
	
	@GetMapping("/board")	
	public String board(Model model) { 

		return "/admin/board";
	}
	
	@GetMapping("/post")	
	public String post(Model model) { 

		return "/admin/list";
	}
	
	@PostMapping("/board/insert")	
	public String boardPost(Model model, String name) {		//메세지jsp에 메세지 주고받으려면 model 필요
		/*
		if(name.trim().isBlank()) {
			model.addAttribute("msg", "게시판 이름을 입력해주세요.");
			return "message";
		}*/
		
		if(postService.insertBoard(name)) {
			model.addAttribute("msg", "게시판을 등록했습니다.");
		}else {
			model.addAttribute("msg", "이미 등록된 게시판입니다.");
		}
		model.addAttribute("url", "/admin/board");
		
		return "message";
	}
	
	@PostMapping("/board/update")	
	public String boardUpdate(Model model, BoardVO board) {	
		
		if(postService.updateBoard(board)) {
			model.addAttribute("msg", "게시판을 수정했습니다.");
		}else {
			model.addAttribute("msg", "이미 등록된 게시판입니다.");
		}
		model.addAttribute("url", "/admin/board");
		
		return "message";
	}

	@GetMapping("/board/delete")	
	public String boardDelete(Model model, int num) {	
		
		if(postService.deleteBoard(num)) {
			model.addAttribute("msg", "게시판을 삭제했습니다.");
		}else {
			model.addAttribute("msg", "게시판을 삭제하지 못했습니다.");
		}
		model.addAttribute("url", "/admin/board");
		
		return "message";
	}

	@PostMapping("/post")
	public Object PostList(Model model, @RequestBody PostCriteria cri) {			
		//cri.setPerPageNum(2);
		List<PostVO> postList = postService.getPostList(cri);
		//System.out.println(postList);
		PageMaker pm = postService.getPageMaker(cri);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String today = sdf.format(new Date());
		
		for(PostVO post : postList) {
			post.setSummary(PostController.htmlToText(post.getPo_content(), 20));			//요약
		}
		
		model.addAttribute("postList", postList);
		model.addAttribute("pm",pm);
		model.addAttribute("today", today);
		
		
		
		return"admin/sub";					
	}
	

	
}
