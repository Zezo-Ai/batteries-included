package kube

import (
	"context"
	"fmt"
	"log/slog"
	"net/http"
	"os"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/labels"
	"k8s.io/client-go/tools/portforward"
	"k8s.io/client-go/transport/spdy"
)

func (kubeClient *batteryKubeClient) PortForwardService(
	namespace string,
	name string,
	port int,
	localPort int,
	stopChannel <-chan struct{},
	readyChannel chan struct{}) (*portforward.PortForwarder, error) {

	// Port forwarding can only target a single pod, so we
	// need to get the pod name from the service
	podName, err := kubeClient.getPodNameFromService(namespace, name)
	if err != nil {
		return nil, err
	}

	portMap := fmt.Sprintf("%d:%d", localPort, port)
	return kubeClient.portForward(namespace, podName, []string{portMap}, stopChannel, readyChannel)
}

func (kubeClient *batteryKubeClient) portForward(
	namespace string,
	podName string,
	portMap []string,
	stopChannel <-chan struct{},
	readyChannel chan struct{}) (*portforward.PortForwarder, error) {

	cfg := kubeClient.kubeConfig

	url := kubeClient.client.CoreV1().
		RESTClient().
		Post().
		Resource("pods").
		Name(podName).
		Namespace(namespace).
		SubResource("portforward").
		URL()

	transport, upgrader, err := spdy.RoundTripperFor(cfg)
	if err != nil {
		return nil, err
	}

	dialer := spdy.NewDialer(upgrader, &http.Client{Transport: transport}, http.MethodPost, url)

	slog.Debug("Starting port forward",
		slog.Any("portMap", portMap),
		slog.Any("url", url))

	return portforward.NewOnAddresses(dialer, []string{"localhost"}, portMap, stopChannel, readyChannel, os.Stdout, os.Stderr)

}

func (kubeClient *batteryKubeClient) getPodNameFromService(namespace string, name string) (string, error) {
	// Get all the running pods that are being targeted by the service
	service, err := kubeClient.client.CoreV1().Services(namespace).Get(context.TODO(), name, metav1.GetOptions{})

	if err != nil {
		return "", err
	}

	// using the selector get all the pods that are being targeted by the service
	listOptions := metav1.ListOptions{
		LabelSelector: labels.FormatLabels(service.Spec.Selector),
	}

	pods, err := kubeClient.client.CoreV1().
		Pods(namespace).
		List(context.TODO(), listOptions)

	if err != nil {
		return "", err
	}

	slog.Debug("Service pods found", slog.Int("podCount", len(pods.Items)))

	if len(pods.Items) == 0 {
		return "", fmt.Errorf("no pods found for service %s", name)
	}
	return pods.Items[0].Name, nil

}
