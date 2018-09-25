package com.manage.action.statistical;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.query.model.MemberQuery;
import com.manage.service.IMemberService;
import com.manage.util.Pager;

/**
 * 会员统计
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/statistic/member")
public class MemberStatisticController extends BaseController{

	@Autowired
	private IMemberService memberService;
	
	@RequestMapping(value="/initMemberStatistic.action")
	public String initGoodsStatistic(ModelMap model){
		return "statistic/memberStatistic";
	}
	
	@RequestMapping(value="/searchMember.action")
	@ResponseBody
	public String searchMember(ModelMap model,MemberQuery memberQuery,Pager pager,String orderBy){
		if(StringUtils.isBlank(orderBy)){
			orderBy="buycount desc";
		}
		memberQuery.setPager(pager);
		memberQuery.setOrderBy(orderBy);
		List<MemberQuery> memberQueries=memberService.selectSumByMemberQuery(memberQuery);
		int count=memberService.countSumByMemberQuery(memberQuery);
		return DataGridJson(memberQueries, count);
	}
	
	@RequestMapping(value="/initDetail.action")
	public String initDetail(ModelMap model,Long id){
		model.put("id", id);
		return "statistic/memberDetail";
	}
}
