package kr.kh.riot.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.kh.riot.model.vo.CommentVO;
import kr.kh.riot.model.vo.UserVO;
import kr.kh.riot.pagination.Criteria;
import kr.kh.riot.pagination.PageMaker;
import kr.kh.riot.service.CommentService;

//컨트롤러 안의 모든 메소드에 @ResponseBody가 붙은 경우에 사용
@Controller
@RequestMapping("/comment")
public class CommentController {

	@Autowired
	CommentService commentService;

	@PostMapping("/insert")
	@ResponseBody
	public boolean insert(@RequestBody CommentVO comment, HttpSession session) {
		UserVO newUser = (UserVO)session.getAttribute("user");
		return commentService.insertComment(comment, newUser);
	}
	
	@GetMapping("/list2")
	public String list2(Model model, Criteria cri) {
		
		List<CommentVO> list= commentService.getCommentList(cri);
		PageMaker pm = commentService.getPageMaker(cri);
		model.addAttribute("commentList", list);
		model.addAttribute("pm", pm);
		return "/comment/list";
	}
	@PostMapping("/list")
	public String list(Model model,@RequestBody Criteria cri) {
		//cri.setPerPageNum(5);
		List<CommentVO> list= commentService.getCommentList(cri);
		PageMaker pm = commentService.getPageMaker(cri);
		model.addAttribute("commentList", list);
		model.addAttribute("pm", pm);
		return "comment/list";
	}
	
	@PostMapping("/delete")
	@ResponseBody
	public boolean delete(@RequestParam int co_key, HttpSession session) {
		UserVO user = (UserVO)session.getAttribute("user");
		return commentService.deleteComment(co_key, user);
	}
	
	@PostMapping("/update")
	@ResponseBody
	public boolean update(@RequestBody CommentVO comment, HttpSession session) {
		UserVO user = (UserVO)session.getAttribute("user");
		return commentService.updateComment(comment, user);
	}
}
