package com.devops.taskmanager.Controller;

import com.devops.taskmanager.Repository.FriendRequestRepository;
import com.devops.taskmanager.Repository.UserRepository;
import com.devops.taskmanager.entities.FriendRequest;
import com.devops.taskmanager.entities.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/friends")
public class FriendshipController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FriendRequestRepository friendRequestRepository;

    @GetMapping
    public String friendsPage(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/login";

        // Refresh user from DB to get latest friends
        User user = userRepository.findById(loggedInUser.getId()).orElse(loggedInUser);
        
        model.addAttribute("friends", user.getFriends());
        model.addAttribute("pendingRequests", friendRequestRepository.findByReceiverAndStatus(user, FriendRequest.RequestStatus.PENDING));
        return "friends";
    }

    @PostMapping("/request")
    public String sendRequest(@RequestParam String username, HttpSession session, Model model) {
        User sender = (User) session.getAttribute("loggedInUser");
        if (sender == null) return "redirect:/login";

        Optional<User> receiverOpt = userRepository.findByUsername(username);
        if (receiverOpt.isEmpty()) {
            return "redirect:/friends?error=user_not_found";
        }

        User receiver = receiverOpt.get();
        if (sender.getId().equals(receiver.getId())) {
            return "redirect:/friends?error=self_request";
        }

        if (friendRequestRepository.findBySenderAndReceiver(sender, receiver).isPresent()) {
            return "redirect:/friends?error=already_sent";
        }

        FriendRequest request = new FriendRequest();
        request.setSender(sender);
        request.setReceiver(receiver);
        request.setStatus(FriendRequest.RequestStatus.PENDING);
        friendRequestRepository.save(request);

        return "redirect:/friends?success=request_sent";
    }

    @PostMapping("/accept")
    public String acceptRequest(@RequestParam Long requestId, HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/login";

        Optional<FriendRequest> requestOpt = friendRequestRepository.findById(requestId);
        if (requestOpt.isPresent()) {
            FriendRequest request = requestOpt.get();
            if (request.getReceiver().getId().equals(loggedInUser.getId()) && 
                request.getStatus() == FriendRequest.RequestStatus.PENDING) {
                
                request.setStatus(FriendRequest.RequestStatus.ACCEPTED);
                friendRequestRepository.save(request);

                User sender = userRepository.findById(request.getSender().getId()).orElse(null);
                User receiver = userRepository.findById(request.getReceiver().getId()).orElse(null);

                if (sender != null && receiver != null) {
                    sender.getFriends().add(receiver);
                    receiver.getFriends().add(sender);

                    userRepository.save(sender);
                    userRepository.save(receiver);
                }
            }
        }
        return "redirect:/friends";
    }

    @PostMapping("/reject")
    public String rejectRequest(@RequestParam Long requestId, HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/login";

        Optional<FriendRequest> requestOpt = friendRequestRepository.findById(requestId);
        if (requestOpt.isPresent() && requestOpt.get().getReceiver().getId().equals(loggedInUser.getId())) {
            FriendRequest request = requestOpt.get();
            request.setStatus(FriendRequest.RequestStatus.REJECTED);
            friendRequestRepository.save(request);
        }
        return "redirect:/friends";
    }
}
