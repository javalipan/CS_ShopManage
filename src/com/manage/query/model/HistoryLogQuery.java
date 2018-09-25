package com.manage.query.model;

import com.manage.dao.model.HistoryLog;
import com.manage.util.Pager;

public class HistoryLogQuery extends HistoryLog{

	private static final long serialVersionUID = 1L;

	private String username;
	
	private String starttime;
	
	private String endtime;
	
	private Pager pager;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getStarttime() {
		return starttime;
	}

	public void setStarttime(String starttime) {
		this.starttime = starttime;
	}

	public String getEndtime() {
		return endtime;
	}

	public void setEndtime(String endtime) {
		this.endtime = endtime;
	}

	public Pager getPager() {
		return pager;
	}

	public void setPager(Pager pager) {
		this.pager = pager;
	}
	
}
