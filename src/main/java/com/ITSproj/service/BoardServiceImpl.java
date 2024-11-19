package com.ITSproj.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ITSproj.model.PagingInfoDTO;
import com.ITSproj.persistence.BoardDAO;
import com.ITSproj.model.BoardDTO;
import com.ITSproj.model.BoardVO;
import com.ITSproj.model.PagingInfo;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	private BoardDAO bDao;

	@Override
	@Transactional(readOnly = true)
	public Map<String, Object> getAllBoard(PagingInfoDTO dto) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		PagingInfo pi = makePagingInfo(dto);
		
		// DAO 단 호출
		List<BoardVO> list = null;
		
		list = bDao.selectAllBoard(pi);
		resultMap.put("pagingInfo", pi);
		resultMap.put("boardList", list);
		return resultMap;
	}

	private PagingInfo makePagingInfo(PagingInfoDTO dto) throws Exception {
		PagingInfo pi = new PagingInfo(dto);
		
		pi.setTotalPostCnt(bDao.getTotalPostCnt()); // 전체 데이터 수 세팅

		pi.setTotalPageCnt(); // 전체 페이지 수 세팅
		pi.setStartRowIndex(); // 현재 페이지에서 보여주기 시작할 rowIndex

		// 페이징 블럭 만들기
		pi.setPageBlockNoCurPage();
		pi.setStartPageNoCurBlock();
		pi.setEndPageNoCurBlock();

		System.out.println(pi.toString());
		return pi;
	}

	@Override
	public boolean modifyBoard(BoardDTO modifyBoard) throws Exception {
		System.out.println("ServiceImpl : " + modifyBoard.toString());
		boolean result = false;
		
		if(bDao.updateBoardByBoardNo(modifyBoard) == 1) {
			result = true;
		}
		return result;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public BoardVO read(int boardNo, String ipAddr) throws Exception {
		
		BoardVO bVO = bDao.selectBoardByBoardNo(boardNo);
		
		if(bVO != null) {
			int dateDiff = bDao.selectDateDiff(boardNo, ipAddr);
			
			if(dateDiff == -1) {
				if(bDao.saveBoardReadLog(boardNo, ipAddr) == 1) {
					updateReadCount(boardNo, bVO);
				}
			} else if (dateDiff >= 1) {
				updateReadCount(boardNo, bVO);
				bDao.updateReadWhen(boardNo, ipAddr);
			}
		}
		return bVO;
	}
	
	private void updateReadCount(int boardNo, BoardVO bVO) throws Exception {
		if(bDao.updateReadCount(boardNo) == 1) {
			bVO.setReadCount(bVO.getReadCount() + 1);
		}
		
	}

	@Override
	@Transactional(readOnly=true)
	public BoardVO read(int boardNo) throws Exception {
		
		BoardVO bVO = bDao.selectBoardByBoardNo(boardNo);
		
		return bVO;
	}

	@Override
	public boolean removeBoard(int boardNo) throws Exception {
		
		boolean result = false;
		
		if(bDao.removeBoardByBoardNo(boardNo) == 1) {
			result = true;
		} else {
			result = false;
		}
		
		return result;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean saveBoard(BoardDTO newBoard) throws Exception {
		boolean result = false;
		
		if(bDao.insertNewBoard(newBoard) == 1) {
			result = true;
		} else {
			result = false;
		}
		
		return result;
	}

	@Override
	@Transactional(readOnly=true)
	public List<BoardVO> getPopularBoards() throws Exception {
		
		return bDao.selectPopularBoards();
	}


}
