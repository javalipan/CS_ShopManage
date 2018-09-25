package com.manage.query.model;

import java.util.Date;
import java.util.List;

import com.manage.dao.model.Member;
import com.manage.dao.model.MemberLabel;
import com.manage.util.Pager;

public class MemberQuery extends Member{

	private static final long serialVersionUID = 1L;
	/**
	 * 消费次数
	 */
	private int buycount;
	/**
	 * 最近消费时间
	 */
	private Date lastbuytime;

	/**
	 * 0:未消费，1：以消费 
	 */
	private String hasBuy;
	
	private String timeStart;
	private String timeEnd;
	
	private String fromname;
	
	/**
	* @Fields downCount : 下级数量
	*/
	private int downCount;
	
	private Long labelId;
	
	private Integer orderCnt;
	
	private Date lastBuyTime;
	
	private String orderBy;
	private Pager pager;
	
	/**
	 * 生日月份查询
	 */
	private Integer month;
	
	private String levelLabel;
	private String moneyLabel;
	private String recentLabel;
	private String repeatLabel;
	private String brandLabel;
	private String sizeLabel;
	private String styleLabel;
	private String timeLabel;
	private Double orderAvgPrice;
	
	private List<MemberLabel> memberLabels;
	private int days;

	public int getBuycount() {
		return buycount;
	}

	public void setBuycount(int buycount) {
		this.buycount = buycount;
	}

	public Date getLastbuytime() {
		return lastbuytime;
	}

	public void setLastbuytime(Date lastbuytime) {
		this.lastbuytime = lastbuytime;
	}

	public String getHasBuy() {
		return hasBuy;
	}

	public void setHasBuy(String hasBuy) {
		this.hasBuy = hasBuy;
	}

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

	public String getTimeStart() {
		return timeStart;
	}

	public void setTimeStart(String timeStart) {
		this.timeStart = timeStart;
	}

	public String getTimeEnd() {
		return timeEnd;
	}

	public void setTimeEnd(String timeEnd) {
		this.timeEnd = timeEnd;
	}

	public String getFromname() {
		return fromname;
	}

	public void setFromname(String fromname) {
		this.fromname = fromname;
	}

	public int getDownCount() {
		return downCount;
	}

	public void setDownCount(int downCount) {
		this.downCount = downCount;
	}

	public Long getLabelId() {
		return labelId;
	}

	public void setLabelId(Long labelId) {
		this.labelId = labelId;
	}

	public Integer getOrderCnt() {
		return orderCnt;
	}

	public void setOrderCnt(Integer orderCnt) {
		this.orderCnt = orderCnt;
	}

	public Date getLastBuyTime() {
		return lastBuyTime;
	}

	public void setLastBuyTime(Date lastBuyTime) {
		this.lastBuyTime = lastBuyTime;
	}

	public Integer getMonth() {
		return month;
	}

	public void setMonth(Integer month) {
		this.month = month;
	}

	public String getLevelLabel() {
		return levelLabel;
	}

	public void setLevelLabel(String levelLabel) {
		this.levelLabel = levelLabel;
	}

	public String getMoneyLabel() {
		return moneyLabel;
	}

	public void setMoneyLabel(String moneyLabel) {
		this.moneyLabel = moneyLabel;
	}

	public String getRecentLabel() {
		return recentLabel;
	}

	public void setRecentLabel(String recentLabel) {
		this.recentLabel = recentLabel;
	}

	public String getRepeatLabel() {
		return repeatLabel;
	}

	public void setRepeatLabel(String repeatLabel) {
		this.repeatLabel = repeatLabel;
	}

	public String getBrandLabel() {
		return brandLabel;
	}

	public void setBrandLabel(String brandLabel) {
		this.brandLabel = brandLabel;
	}

	public String getSizeLabel() {
		return sizeLabel;
	}

	public void setSizeLabel(String sizeLabel) {
		this.sizeLabel = sizeLabel;
	}

	public String getStyleLabel() {
		return styleLabel;
	}

	public void setStyleLabel(String styleLabel) {
		this.styleLabel = styleLabel;
	}

	public String getTimeLabel() {
		return timeLabel;
	}

	public void setTimeLabel(String timeLabel) {
		this.timeLabel = timeLabel;
	}

	public Double getOrderAvgPrice() {
		return orderAvgPrice;
	}

	public void setOrderAvgPrice(Double orderAvgPrice) {
		this.orderAvgPrice = orderAvgPrice;
	}

	public List<MemberLabel> getMemberLabels() {
		return memberLabels;
	}

	public void setMemberLabels(List<MemberLabel> memberLabels) {
		this.memberLabels = memberLabels;
	}

	public int getDays() {
		return days;
	}

	public void setDays(int days) {
		this.days = days;
	}
	
}
