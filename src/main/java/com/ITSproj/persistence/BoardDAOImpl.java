package com.ITSproj.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.ITSproj.model.BoardDTO;
import com.ITSproj.model.BoardVO;
import com.ITSproj.model.PagingInfo;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class BoardDAOImpl implements BoardDAO {

	private final SqlSession ses;
	private static final String NS = "com.ITSproj.mappers.boardMapper";

	@Override
	public List<BoardVO> selectAllBoard(PagingInfo pi) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();

		params.put("startRowIndex", pi.getStartRowIndex());
		params.put("viewPostCntPerPage", pi.getViewPostCntPerPage());

		return ses.selectList(NS + ".getBoardWithPaging", params);
	}

	@Override
	public int getTotalPostCnt() throws Exception {
		
		return ses.selectOne(NS + ".selectTotalCount");
	}

	@Override
	public int updateBoardByBoardNo(BoardDTO modifyBoard) throws Exception {
		System.out.println("BoardDAOImpl : " + modifyBoard.toString());
		
		return ses.update(NS + ".updateBoardByBoardNo", modifyBoard);
	}

	@Override
	public BoardVO selectBoardByBoardNo(int boardNo) throws Exception {
		
		return ses.selectOne(NS + ".selectBoardDetailInfoByBoardNo", boardNo);
	}

	@Override
	public int selectDateDiff(int boardNo, String ipAddr) throws Exception {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("readwho", ipAddr);
		params.put("boardNo", boardNo);
		return ses.selectOne(NS + ".selectBoardDateDiff", params);
	}

	@Override
	public int saveBoardReadLog(int boardNo, String ipAddr) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		System.out.println(ipAddr + "++++++++++++++++++++");
		params.put("readwho", ipAddr);
		params.put("boardNo", boardNo);
		
		return ses.insert(NS + ".saveBoardReadLog", params);
		
	}

	@Override
	public int updateReadCount(int boardNo) throws Exception {
		
		return ses.update(NS + ".updateReadCount", boardNo); 
	}

	@Override
	public int updateReadWhen(int boardNo, String ipAddr) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("readwho", ipAddr);
		params.put("boardNo", boardNo);
		return ses.update(NS + ".updateBoardReadLog", params);
	}

	@Override
	public int removeBoardByBoardNo(int boardNo) throws Exception {
		
		return ses.delete(NS + ".removeBoardByBoardNo", boardNo);
	}

	@Override
	public int insertNewBoard(BoardDTO newBoard) throws Exception {
		
		return ses.insert(NS + ".saveNewBoard", newBoard);
	}
	
	@Override
	public List<BoardVO> selectPopularBoards() throws Exception {

		return ses.selectList(NS + ".selectPopBoards");
	}

}
