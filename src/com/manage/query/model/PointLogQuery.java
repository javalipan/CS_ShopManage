package com.manage.query.model;

import com.manage.dao.model.PointLog;
import com.manage.util.Pager;

public class PointLogQuery extends PointLog {

	private static final long serialVersionUID = 1L;

	private String nickname;
	private String code;
	private Pager pager;
	private String orderBy;

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public Pager getPager() {
		return pager;
	}

	public void setPager(Pager pager) {
		this.pager = pager;
	}

	public String getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

}
