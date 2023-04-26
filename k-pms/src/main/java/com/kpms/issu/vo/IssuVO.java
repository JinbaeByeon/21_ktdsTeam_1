package com.kpms.issu.vo;

import com.kpms.common.vo.AbstractPagingVO;

/**
 * ISSU
 */
public class IssuVO extends AbstractPagingVO {

	private String issuId;
	private String reqId;
	private String issuTtl;
	private String issuCntnt;
	private int vwCnt;
	private String dffclty;
	private String dtlCntnt;
	private String mnTmMbrId;
	private String stts;


	public void setIssuId(String issuId) {
		this.issuId = issuId;
	}

	public String getIssuId() {
		return this.issuId;
	}

	public String getReqId() {
		return reqId;
	}

	public void setReqId(String reqId) {
		this.reqId = reqId;
	}

	public void setIssuTtl(String issuTtl) {
		this.issuTtl = issuTtl;
	}

	public String getIssuTtl() {
		return this.issuTtl;
	}

	public void setIssuCntnt(String issuCntnt) {
		this.issuCntnt = issuCntnt;
	}

	public String getIssuCntnt() {
		return this.issuCntnt;
	}

	public void setVwCnt(int vwCnt) {
		this.vwCnt = vwCnt;
	}

	public int getVwCnt() {
		return this.vwCnt;
	}

	public void setDffclty(String dffclty) {
		this.dffclty = dffclty;
	}

	public String getDffclty() {
		return this.dffclty;
	}

	public void setDtlCntnt(String dtlCntnt) {
		this.dtlCntnt = dtlCntnt;
	}

	public String getDtlCntnt() {
		return this.dtlCntnt;
	}

	public void setMnTmMbrId(String mnTmMbrId) {
		this.mnTmMbrId = mnTmMbrId;
	}

	public String getMnTmMbrId() {
		return this.mnTmMbrId;
	}

	public void setStts(String stts) {
		this.stts = stts;
	}

	public String getStts() {
		return this.stts;
	}

}