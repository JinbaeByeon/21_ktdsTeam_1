package com.kpms.tm.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kpms.common.exception.APIArgsException;
import com.kpms.common.exception.APIException;
import com.kpms.tm.dao.TmDAO;
import com.kpms.tm.vo.TmVO;

@Service
public class TmServiceImpl implements TmService {

	@Autowired
	private TmDAO tmDAO;

	@Override
	public List<TmVO> readAllTmVO(TmVO tmVO) {
		return tmDAO.readAllTmVO(tmVO);
	}

	@Override
	public List<TmVO> readAllTmVONopagination(String tmNm) {
		return tmDAO.readAllTmVONopagination(tmNm);
	}

	@Override
	public TmVO readOneTmVOByTmId(String tmId) {
		return tmDAO.readOneTmVOByTmId(tmId);
	}

	@Override
	public boolean createOneTm(TmVO tmVO) {
		
//		int tmCreateCount = tmDAO.createOneTm(tmVO);
//		if (tmCreateCount > 0) {
//			
//			List<EmpVO> empList = depVO.getEmpList();
//			if (empList == null || empList.isEmpty()) {
//				throw new APIArgsException("404", "팀장을 선택하세요.");
//			}
//			for (EmpVO emp: empList) {
//				empDAO.createOneEmp(emp);
//			}
//		}
//		
//		return tmCreateCount > 0;
		if (tmVO.getTmNm() == null || tmVO.getTmNm().trim().length() == 0) {
			throw new APIArgsException("400", "팀명이 누락되었습니다.");
		}
		
		return tmDAO.createOneTm(tmVO) > 0;
	}

	@Override
	public boolean updateOneTm(TmVO tmVO) {
		return tmDAO.updateOneTm(tmVO) > 0;
	}

	@Override
	public boolean deleteOneTmByTmId(String tmId) {
		return tmDAO.deleteOneTmByTmId(tmId) > 0;
	}

	@Override
	public boolean deleteTmBySelectedTmId(List<String> tmId) {
		int delCount = tmDAO.deleteTmBySelectedTmId(tmId);
		boolean isSuccess = delCount == tmId.size();
		
		if (!isSuccess) {
			throw new APIException("500", "삭제에 실패했습니다. 요청건수:("+tmId.size() +"건), 삭제건수:("+delCount+"건)");
		}
		
		return isSuccess;
	}
	
}