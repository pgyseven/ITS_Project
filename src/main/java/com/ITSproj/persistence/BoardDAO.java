package com.ITSproj.persistence;

import java.util.List;

import com.ITSproj.model.BoardDTO;
import com.ITSproj.model.BoardVO;
import com.ITSproj.model.PagingInfo;

public interface BoardDAO {

	List<BoardVO> selectAllBoard(PagingInfo pi) throws Exception;

	int getTotalPostCnt() throws Exception;

	int updateBoardByBoardNo(BoardDTO modifyBoard) throws Exception;

	//게시글 상세정보를 읽어오는 메서드
	BoardVO selectBoardByBoardNo(int boardNo) throws Exception;

	// ipAddr의 유저가 boardNo글을 언제 조회했는지 날짜 차이를 얻어온다.(조회한 적이 없다면 -1 반환)
	int selectDateDiff(int boardNo, String ipAddr) throws Exception;

	//ipAddr의 유저가 boardNo 글을 현재 시간에 조회한다고 기록
	int saveBoardReadLog(int boardNo, String ipAddr) throws Exception;

	//게시글의 조회수를 증가하는 메서드
	int updateReadCount(int boardNo) throws Exception;

	//조회수 증가한 날짜로 update  
	int updateReadWhen(int boardNo, String ipAddr) throws Exception;

	int removeBoardByBoardNo(int boardNo) throws Exception;

	//게시글을 저장하는 메소드
	int insertNewBoard(BoardDTO newBoard) throws Exception;

	// 조회수 높은 순으로 게시글 5개 가져오기
	List<BoardVO> selectPopularBoards() throws Exception;

}
