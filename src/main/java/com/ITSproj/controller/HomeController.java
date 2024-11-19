package com.ITSproj.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ITSproj.model.BoardVO;
import com.ITSproj.model.MemberVO;
import com.ITSproj.model.RoadReplyDTO;
import com.ITSproj.model.RoadReplyVO;
import com.ITSproj.service.BoardService;
import com.ITSproj.service.MemberService;
import com.ITSproj.service.RoadReplyService;

@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Autowired
	private BoardService bService;

	@Autowired
	private RoadReplyService roadService;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model) {

		System.out.println("홈페이지에 보여줄 게시판 최신글 5개만 가져오자..");

		try {
			List<BoardVO> list = bService.getPopularBoards();
			model.addAttribute("list", list);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "index";
	}

	@RequestMapping("/map")
	public void goMap() {}

	// =======================================최미설
	// ============================================
	// 1. 로그인
	@Autowired
	private MemberService mService;

	@RequestMapping("/loginPage")
	public void loginPage() {
		System.out.println("로그인 페이지로 이동");
	}

	@RequestMapping(value = "/login", method = RequestMethod.POST)
    public void login(@RequestParam("userId") String userId, @RequestParam("userPwd") String userPwd,
          HttpSession session, Model model) {
       //, RedirectAttributes redirectAttributes
       System.out.println(userId + ": " + userPwd);
       String result = "fail";
       // 로그인 시키는 메서드
       try {
          MemberVO loginMember = mService.loginMember(userId, userPwd);

          if (loginMember != null ) {
             System.out.println(loginMember);
             session.setAttribute("loginMember", loginMember);
             model.addAttribute("status", "loginSuccess");
                
          } else { // 로그인 실패시
             System.out.println("로그인 실패");
             model.addAttribute("status", "loginFail");
          }
       } catch (Exception e) {
            e.printStackTrace();
       }
    } 

	@RequestMapping("/logout")
	public String logoutMember(HttpSession session) {
		System.out.println("로그아웃 이전의 세션 : " + session.getId());
		// 세션에 저장했던 값들을 지우고
		if (session.getAttribute("loginMember") != null) {
			session.removeAttribute("loginMember"); // 무효화된 세션은 예외를 던지므로
			// 세션 안의 값만 무효화(세션이 없어지는 건 아님, 서버에 접속되어 있으면 그대로 갖고 있음)
			session.removeAttribute("destPath"); // 로그아웃 후 원래 접근하려고 했던 경로(세션에 저장됨) 무효화
			session.invalidate();
		}
		System.out.println("로그아웃 이후의 세션 : " + session.getId());
		return "redirect:/";

	}

	// 2. ITS 1차
	@RequestMapping("/ITSKGY")
	public void itsTest1() {

	}

	@RequestMapping("/ITSCMS")
	public void itsTest2() {

	}

	@RequestMapping("/ITSPGY")
	public void itsTest3() {

	}
	// =======================================최미설
	// ============================================

	@RequestMapping(value="/getUnitCode", produces = "application/json; charset=UTF-8;")
	@ResponseBody
	public Map<String, Object> getUnitCode(@RequestParam("unitCode") String unitCode) {

		System.out.println("유저가 조회한 지역의 유닛코드 : " + unitCode);

		Map<String, Object> result = new HashMap<>();

		try {
			List<RoadReplyVO> replies = roadService.getRoadRepliesByUnitCode(unitCode);
			result.put("msg", "success");
			result.put("RoadReply", replies); // 필요시 데이터를 함께 전송

			System.out.println("가져온 댓글 : " + replies.toString());
		} catch (Exception e) {
			result.put("msg", "error");
		}

		return result;
	}

	@RequestMapping(value = "/saveReply" , method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> saveReply(@RequestBody Map<String, String> replyData, HttpSession session) {
		String content = replyData.get("content");
		String unitCode = replyData.get("unitCode");

		String replyer = ((MemberVO)session.getAttribute("loginMember")).getUserId();
		
		RoadReplyDTO roadDTO = new RoadReplyDTO(replyer, content, unitCode);

		try {
			// DB에 댓글 저장 로직
			boolean insertYN = roadService.insertReply(roadDTO);
			
			Map<String, Object> resultMap = new HashMap<String, Object>();
			
			List<RoadReplyVO> replies = roadService.getRoadRepliesByUnitCode(unitCode);
			
			resultMap.put("insertYN", insertYN);
			resultMap.put("replies", replies);
			
			
			
			System.out.println("댓글을 저장하자 : " + roadDTO.toString());
			
			return ResponseEntity.ok(resultMap);
		} catch (Exception e) {
			// 예외 처리 (예: DB 저장 실패 등)
			e.printStackTrace();
			return (ResponseEntity<Map<String, Object>>) ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR);
		}

	}
	
	@PostMapping(value="removeRoadReply", produces = "application/json; charset=UTF-8;")
	public ResponseEntity<Map<String, String>> removeRoadReply(@RequestBody int roadReplyNo) {
		System.out.println(roadReplyNo + "번 글을 삭제하자");
		
		Map<String, String> response = new HashMap<>();
		
		try {
			roadService.removeRoadReply(roadReplyNo);
			response.put("message", "댓글이 삭제되었습니다.");
			return new ResponseEntity<>(response, HttpStatus.OK);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			response.put("message", "댓글 삭제 실패");
			return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
		}
	}

}
