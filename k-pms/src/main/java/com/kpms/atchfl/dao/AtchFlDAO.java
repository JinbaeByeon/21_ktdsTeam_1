package com.kpms.atchfl.dao;

import java.util.List;

import com.kpms.atchfl.vo.AtchFlVO;

public interface AtchFlDAO {

	public int createNewAtchFl(AtchFlVO atchFlVO);
	public int deleteNewAtchFl(String frgnId);
	public int createNewAtchFls(List<AtchFlVO> fileList);
}
