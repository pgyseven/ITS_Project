package com.ITSproj.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ITSproj.model.BoardDTO;
import com.ITSproj.model.BoardVO;
import com.ITSproj.model.MemberVO;
import com.ITSproj.model.PagingInfoDTO;
import com.ITSproj.model.ReplyDTO;
import com.ITSproj.model.ReplyVO;
import com.ITSproj.service.BoardService;
import com.ITSproj.service.ReplyService;
import com.ITSproj.util.GetClientIPAddr;

import lombok.RequiredArgsConstructor;

import com.ITSproj.model.PagingInfo;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board")
public class BoardController {

	// Log를 남길 수 있도록 하는 객체
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);

	@Autowired
	private BoardService bService;

	@Autowired
	private ReplyService rService;

	@RequestMapping("/list")
	public void bringList(Model model, @RequestParam(value = "pageNo", defaultValue = "1") int pageNo,
			@RequestParam(value = "pagingSize", defaultValue = "5") int pagingSize) {
		System.out.println("Controller~ 게시판 목록 불러오기");

		PagingInfoDTO dto = PagingInfoDTO.builder().pageNo(pageNo).pagingSize(pagingSize).build();

		Map<String, Object> result = null;

		try {
			result = bService.getAllBoard(dto);

			PagingInfo pi = (PagingInfo) result.get("pagingInfo");
			List<BoardVO> list = (List<BoardVO>) result.get("boardList");

			model.addAttribute("boardList", list); // 데이터 바인딩
			model.addAttribute("PagingInfo", pi);
			System.out.println(list.toString());
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("exception", "error");
		}
	}

	@RequestMapping(value = { "/detail", "/modifyBoard" })
	public String viewBoard(@RequestParam("boardNo") int boardNo, Model model, HttpServletRequest request) {

		String ipAddr = GetClientIPAddr.getClientIp(request);
		System.out.println(ipAddr + "가 " + boardNo + "번 글을 조회한다!");

		String returnViewPage = "";

		BoardVO bVO = null;
		List<ReplyVO> rVO = null;

		try {
			if (request.getRequestURI().equals("/board/detail")) {

				System.out.println("상세보기 호출...");
				returnViewPage = "/board/detail";
				bVO = bService.read(boardNo, ipAddr);
				rVO = rService.getReply(boardNo);

				System.out.println(rVO.toString());

			} else if (request.getRequestURI().equals("/board/modifyBoard")) {

				System.out.println("수정하기 호출...");
				returnViewPage = "/board/modifyBoard";
				bVO = bService.read(boardNo);

			}

		} catch (Exception e1) {

			e1.printStackTrace();
			returnViewPage = "redirect:/board/list?status=fail";
		}

		model.addAttribute("board", bVO);
		model.addAttribute("reply", rVO);

		return returnViewPage;
	}

	@RequestMapping(value = "/modifyBoardSave", method = RequestMethod.POST)
	public String modifyBoardSave(BoardDTO modifyBoard, RedirectAttributes redirectAttributes) {
		System.out.println(modifyBoard.toString() + "로 수정하자");
		System.out.println("넘어온 boardNo: " + modifyBoard.getBoardNo());
		try {

			if (bService.modifyBoard(modifyBoard)) {
				redirectAttributes.addAttribute("status", "success");
			}
		} catch (Exception e) { // DB의 익셉션 및 IO 익셉션을 모두 포함하기 위하여 익셉션으로 바꿈

			e.printStackTrace();
			redirectAttributes.addAttribute("status", "fail");
		}
		return "redirect:/board/detail?boardNo=" + modifyBoard.getBoardNo();
	}

	@RequestMapping("/showSaveBoardForm")
	public String showBoardSave() {
		return "/board/boardSave";
	}

	@RequestMapping(value = "/boardSave", method = RequestMethod.POST)
	public String saveBoard(BoardDTO newBoard, RedirectAttributes redirectAttributes) {
		System.out.println(newBoard + " 저장하자~~~");

		String returnPage = "redirect:/board/list";

		try {
			if (bService.saveBoard(newBoard)) {
				redirectAttributes.addAttribute("status", "success");
			}
		} catch (Exception e) {
			e.printStackTrace();

			redirectAttributes.addAttribute("status", "fail");
		}
		return returnPage;
	}

	@RequestMapping("/removeBoard")
	public String removeBoard(@RequestParam("boardNo") int boardNo, RedirectAttributes redirectAttributes,
			HttpServletRequest request) {

		System.out.println(boardNo + "번 글을 삭제하자");

		try {
			boolean isDeleted = bService.removeBoard(boardNo);
			redirectAttributes.addAttribute("status", "success");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			redirectAttributes.addAttribute("status", "fail");
		}

		return "redirect:/board/list";

	}

	@RequestMapping(value = "/saveReply", method = RequestMethod.POST, produces = "application/text; charset=UTF-8;")
	public ResponseEntity<String> saveReply(@RequestBody ReplyDTO replyDTO, HttpSession session) {
		// 세션에서 userId를 replyer로 가져오기
		String replyer = ((MemberVO)session.getAttribute("loginMember")).getUserId();

		// replyDTO에 replyer 설정
		replyDTO.setReplyer(replyer);
		
		try {
			rService.insertReply(replyDTO);
			System.out.println(replyDTO.toString());
			return ResponseEntity.ok("댓글이 저장되었습니다.");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 저장 중 오류가 발생했습니다.");
		}

	}
	
	
	
	@PostMapping(value = "/modifyReply", produces = "application/json; charset=UTF-8;")
	public ResponseEntity<String> modifyReply(@RequestBody ReplyDTO replyDTO, HttpSession session) {
		
		System.out.println("댓글 수정하러 컨트롤러 들어왔다");
		System.out.println("수정할 댓글 번호: " + replyDTO.getReplyNo());
	    System.out.println("수정할 내용: " + replyDTO.getContent());
		
		String replyer = ((MemberVO)session.getAttribute("loginMember")).getUserId();
		System.out.println(replyer);
		
		replyDTO.setReplyer(replyer);
		
		try {
			rService.updateReply(replyDTO);
			System.out.println(replyDTO.toString());
			return new ResponseEntity<String>("댓글이 수정되었습니다.", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("수정 실패", HttpStatus.NOT_ACCEPTABLE);
		}
	}
	
	@PostMapping(value = "/removeReply", produces = "application/json; charset=UTF-8;")
	public ResponseEntity<Map<String, String>> removeReply(@RequestBody int replyNo) {

		System.out.println(replyNo + "번 글을 삭제하자");

		Map<String, String> response = new HashMap<>();
		
		try {
			rService.removeReply(replyNo);
			response.put("message", "댓글이 삭제되었습니다.");
	        return new ResponseEntity<>(response, HttpStatus.OK);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			response.put("message", "삭제 실패");
	        return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
		}

	}

}
