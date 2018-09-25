package com.manage.query.model;

import com.manage.dao.model.GoodsBrowseHis;
import com.manage.util.Pager;

public class GoodsBrowseHisQuery extends GoodsBrowseHis {

	private static final long serialVersionUID = 1L;

	private Long brandid;
	/**
	 * 商品名称
	 */
	private String name;
	/**
	* 会员昵称
	*/
	private String membernickname;
	/**
	* 会员手机号
	*/
	private String phone;
	/**
	* 时间起
	*/
	private String startTime;
	/**
	* 时间止
	*/
	private String endTime;
	/**
	 * 浏览量
	 */
	private int cnt;
	private String orderBy;
	private Pager pager;

	public String getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}

	public Pager getPager() {
		return pager;
	}

	public void setPager(Pager pager) {
		this.pager = pager;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getCnt() {
		return cnt;
	}

	public void setCnt(int cnt) {
		this.cnt = cnt;
	}

	public Long getBrandid() {
		return brandid;
	}

	public void setBrandid(Long brandid) {
		this.brandid = brandid;
	}

	public String getMembernickname() {
		return membernickname;
	}

	public void setMembernickname(String membernickname) {
		this.membernickname = membernickname;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

}
